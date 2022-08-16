//
//  AudioWebRTCClient.swift
//
//  Created by Tiago Daniel Jacobs on 20/04/22.

import Foundation
import WebRTC
import os

public protocol AudioWebRTCClientDelegate: AnyObject {
    func webRTCClient(_ client: AudioWebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate)
    func webRTCClient(_ client: AudioWebRTCClient, didChangeIceConnectionState state: RTCIceConnectionState)
    func webRTCClient(_ client: AudioWebRTCClient, didChangeIceGatheringState state: RTCIceGatheringState)
    func webRTCClient(_ client: AudioWebRTCClient, didChangeSignalingState state: RTCSignalingState)
}

open class AudioWebRTCClient: NSObject {
    private var logger = os.Logger(subsystem: "BigBlueButtonTabletSDK", category: "AudioWebRTCClient")
    private var iceGatheringComplete:Bool = false
    
    // The `RTCPeerConnectionFactory` is in charge of creating new RTCPeerConnection instances.
    // A new RTCPeerConnection should be created every new call, but the factory is shared.
    private static let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        videoEncoderFactory.preferredCodec = RTCVideoCodecInfo(name: kRTCVideoCodecVp8Name)
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()
    
    public weak var delegate: AudioWebRTCClientDelegate?
    private let peerConnection: RTCPeerConnection
    private let rtcAudioSession =  RTCAudioSession.sharedInstance()
    private let audioQueue = DispatchQueue(label: "audio")
    private let mediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                                   kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueFalse]
    private var videoSource: RTCVideoSource?
    private var videoCapturer: RTCVideoCapturer?
    private var localVideoTrack: RTCVideoTrack?
    private var isRatioDefined:Bool=false
    
    private var isActiveObserver1:NSKeyValueObservation?

    @available(*, unavailable)
    override init() {
        fatalError("WebRTCClient:init is unavailable")
    }
    
    public required init(iceServers: [String]) {
        let config = RTCConfiguration()
        config.iceServers = [RTCIceServer(urlStrings: iceServers)]
        
        // Unified plan is more superior than planB
        config.sdpSemantics = .unifiedPlan
        
        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        // gatherOnce will get candidates only on beginning (this is how BBB expect to have it for now, so we use this one)
        config.continualGatheringPolicy = .gatherOnce
        
        
        // Define media constraints. DtlsSrtpKeyAgreement is required to be true to be able to connect with web browsers.
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil,
                                              optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue])
        
        guard let peerConnection = AudioWebRTCClient.factory.peerConnection(with: config, constraints: constraints, delegate: nil) else {
            fatalError("Could not create new RTCPeerConnection")
        }
        
        self.peerConnection = peerConnection
        
        super.init()
        createMediaSenders()
         configureAudioSession()
        self.peerConnection.delegate = self
    }
    
    // MARK: Signaling
    
    public func offer() async throws -> RTCSessionDescription {
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains, optionalConstraints: nil)
        let sdp = try await self.peerConnection.offer(for: constrains)
        try await self.peerConnection.setLocalDescription(sdp)
        return sdp
    }
    
    public func setRemoteSDP(remoteSDP: String) async throws {
        let rtcSessionDescription = RTCSessionDescription(type: RTCSdpType.answer, sdp: remoteSDP)
        try await self.peerConnection.setRemoteDescription(rtcSessionDescription)
    }
    
//    public func setRemoteCandidate(remoteIceCandidate: IceCandidate) async throws {
//        let rtcRemoteCandidate = RTCIceCandidate(sdp: remoteIceCandidate.candidate, sdpMLineIndex: remoteIceCandidate.sdpMLineIndex, sdpMid: remoteIceCandidate.sdpMid)
//         try await self.peerConnection.add(rtcRemoteCandidate)
//    }
    
    func set(remoteCandidate: RTCIceCandidate, completion: @escaping (Error?) -> ()) {
        self.peerConnection.add(remoteCandidate, completionHandler: completion)
    }
    
    // MARK: Media
    
    public func push(videoFrame: RTCVideoFrame) {
        guard videoCapturer != nil, videoSource != nil else { return }
        videoSource!.capturer(videoCapturer!, didCapture: videoFrame)
        print("RTCVideoFrame pushed to server.")
    }
    
    private func configureAudioSession() {
        self.rtcAudioSession.lockForConfiguration()
        
        do {
            try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
            try self.rtcAudioSession.session.setCategory(AVAudioSession.Category.playAndRecord, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat.rawValue)
            
        } catch let error {
            debugPrint("Error changing AVAudioSession category: \(error)")
        }
        self.rtcAudioSession.unlockForConfiguration()
        
        self.isActiveObserver1 = self.rtcAudioSession.observe(\.isActive, options: [.new]) { (defaults, change) in
            if(!self.rtcAudioSession.isActive) {
                self.logger.info("isActive changed to false, restoring it");
                self.restoreAudioSession()
            }
        }
    }
    
    private func createMediaSenders() {
        let streamId = "stream"
        
        // Audio
         let audioTrack = self.createAudioTrack()
         self.peerConnection.add(audioTrack, streamIds: [streamId])
    }
    
    private func createAudioTrack() -> RTCAudioTrack {
        let audioConstrains = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = AudioWebRTCClient.factory.audioSource(with: audioConstrains)
        let audioTrack = AudioWebRTCClient.factory.audioTrack(with: audioSource, trackId: "audio0")
        return audioTrack
    }
}

// MARK: RTCPeerConnectionDelegate Methods

extension AudioWebRTCClient: RTCPeerConnectionDelegate {
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        self.logger.info("peerConnection new signaling state: \(stateChanged.rawValue)")
        
        self.delegate?.webRTCClient(self, didChangeSignalingState: stateChanged)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        self.logger.info("peerConnection did add stream \(stream.streamId)")
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        self.logger.info("peerConnection did remove stream \(stream.streamId)")
    }
    
    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        self.logger.info("peerConnection should negotiate")
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        self.logger.info("peerConnection new connection state: \(newState.rawValue)")
        self.delegate?.webRTCClient(self, didChangeIceConnectionState: newState)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        self.logger.info("peerConnection new gathering state: \(newState.rawValue)")
        self.delegate?.webRTCClient(self, didChangeIceGatheringState: newState)
        
        if(newState == .complete) {
            self.logger.info("peerConnection new gathering state is COMPLETE")
            self.iceGatheringComplete = true
        } else if(newState == .gathering) {
            self.logger.info("peerConnection new gathering state is GATHERING")
        } else if(newState == .new) {
            self.logger.info("peerConnection new gathering state is NEW")
        }
    }
    
    public func isIceGatheringComplete() -> Bool {
        return iceGatheringComplete;
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        self.logger.info("peerConnection discovered new candidate")
        self.delegate?.webRTCClient(self, didDiscoverLocalCandidate: candidate)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        self.logger.info("peerConnection did remove candidate(s)")
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        self.logger.info("peerConnection did open data channel")
    }
}

extension AudioWebRTCClient {
    private func setTrackEnabled<T: RTCMediaStreamTrack>(_ type: T.Type, isEnabled: Bool) {
        peerConnection.transceivers
            .compactMap { return $0.sender.track as? T }
            .forEach { $0.isEnabled = isEnabled }
    }
}

// MARK: - Video control

extension AudioWebRTCClient {
    func hideVideo() {
        self.setVideoEnabled(false)
    }
    func showVideo() {
        self.setVideoEnabled(true)
    }
    private func setVideoEnabled(_ isEnabled: Bool) {
        setTrackEnabled(RTCVideoTrack.self, isEnabled: isEnabled)
    }
}

// MARK:- Audio control

extension AudioWebRTCClient {
    func muteAudio() {
        self.setAudioEnabled(false)
    }
    
    func unmuteAudio() {
        self.setAudioEnabled(true)
    }
    
    // Fallback to the default playing device: headphones/bluetooth/ear speaker
    func speakerOff() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.none)
            } catch let error {
                debugPrint("Error setting AVAudioSession category: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }
    
    // Force speaker
    func speakerOn() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.speaker)
                try self.rtcAudioSession.setActive(true)
            } catch let error {
                debugPrint("Couldn't force audio to speaker: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }
    
    public func restoreAudioSession() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                self.rtcAudioSession.lockForConfiguration()
                try RTCAudioSession.sharedInstance().setActive(true)
                self.rtcAudioSession.unlockForConfiguration()
            } catch let error {
                debugPrint("Couldn't restore isActive: \(error)")
            }
        }
    }
    
    private func setAudioEnabled(_ isEnabled: Bool) {
        setTrackEnabled(RTCAudioTrack.self, isEnabled: isEnabled)
    }
}

extension AudioWebRTCClient: RTCDataChannelDelegate {
    public func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        debugPrint("dataChannel did change state: \(dataChannel.readyState)")
    }
    
    public func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        debugPrint("dataChannel did receive message with buffer: \(buffer)")
    }
}
