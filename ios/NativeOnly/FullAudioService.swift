//
//  FullAudioService.swift
//  bigbluebutton-mobile-sdk
//
//  Created by Tiago Daniel Jacobs on 20/04/22.
//
import os
import bigbluebutton_tablet_sdk_common
import WebRTC

open class FullAudioService {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonTabletSDK", category: "FullAudioService")
    private var webRTCClient:AudioWebRTCClient?
    private let encoder = JSONEncoder()

    public func createOffer() async -> String? {
        do{
            webRTCClient = AudioWebRTCClient(iceServers: ["stun:stun.l.google.com:19302",
                                         "stun:stun1.l.google.com:19302",
                                         "stun:stun2.l.google.com:19302",
                                         "stun:stun3.l.google.com:19302",
                                         "stun:stun4.l.google.com:19302"])
            webRTCClient!.delegate = self
            
            var createOfferIterations = 0
            while(true) {
                createOfferIterations += 1;
                
                let rtcSessionDescription = try await self.webRTCClient!.offer()
                
                // Immediately connect when ice gathering is complete or after 5 iterations (5 seconds)
                if(webRTCClient!.isIceGatheringComplete()) {
                    logger.debug("Ice gathering complete!");
                    return rtcSessionDescription.sdp
                } else if ( createOfferIterations > 5 ) {
                    logger.debug("Ice iterations exceeded, sending what we have");
                    return rtcSessionDescription.sdp
                } else {
                    logger.debug("Ice gathering not yet complete, waiting 1s");
                    try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
                }
            }
        } catch {
            logger.error("Error on webRTCClient.offer")
            return nil
        }
    }
    
    public func setRemoteSDP(remoteSDP:String) async -> Bool  {
        do {
            try await self.webRTCClient!.setRemoteSDP(remoteSDP: remoteSDP)
            return true
        }
        catch {
            return false
        }
    }
    
}

extension FullAudioService: AudioWebRTCClientDelegate {
    
    public func webRTCClient(_ client: AudioWebRTCClient, didDiscoverLocalCandidate rtcIceCandidate: RTCIceCandidate) {
        do {
            let iceCandidate = IceCandidate(from: rtcIceCandidate)
            let iceCandidateAsJsonData = try self.encoder.encode(iceCandidate)
            let iceCandidateAsJsonString = String(decoding: iceCandidateAsJsonData, as: UTF8.self)

            print("---- ICE CANDIDATE \(iceCandidateAsJsonString) ")
        } catch {
            self.logger.error("Error handling ICE candidate")
        }
    }
    
    public func webRTCClient(_ client: AudioWebRTCClient, didChangeIceConnectionState state: RTCIceConnectionState) {
        switch state {
        case .connected:
            self.logger.info("didChangeConnectionState -> connected")
        case .completed:
            self.logger.info("didChangeConnectionState -> completed")
        case .disconnected:
            self.logger.info("didChangeConnectionState -> disconnected")
        case .failed:
            self.logger.info("didChangeConnectionState -> failed")
        case .closed:
            self.logger.info("didChangeConnectionState -> closed")
        case .new, .checking, .count:
           break
        @unknown default:
            print("Unknown connection state.")
        }
    }
    
    public func webRTCClient(_ client: AudioWebRTCClient, didChangeIceGatheringState state: RTCIceGatheringState) {
        switch state {
        case .new:
            self.logger.info("didChangeGatheringState -> new")
        case .gathering:
            self.logger.info("didChangeGatheringState -> gathering")
        case .complete:
            self.logger.info("didChangeGatheringState -> complete")
        @unknown default:
            self.logger.error("Unknown gathering state: \(state.rawValue)")
        }
    }
    
    public func webRTCClient(_ client: AudioWebRTCClient, didChangeSignalingState state: RTCSignalingState) {
        var stateString = ""
        switch(state) {
        case .haveLocalOffer:
            self.logger.info("peerConnection new signaling state -> haveLocalOffer")
            stateString = "have-local-offer"
        case .haveLocalPrAnswer:
            self.logger.info("peerConnection new signaling state -> haveLocalPrAnswer")
            stateString = "have-local-pranswer"
        case .haveRemoteOffer:
            self.logger.info("peerConnection new signaling state -> haveRemoteOffer")
            stateString = "have-remote-offer"
        case .haveRemotePrAnswer:
            self.logger.info("peerConnection new signaling state -> haveRemotePrAnswer")
            stateString = "have-remote-pranswer"
        case .stable:
            self.logger.info("peerConnection new signaling state -> stable")
            stateString = "stable"
        case .closed:
            self.logger.info("peerConnection new signaling state -> closed")
            stateString = "closed"
        default:
            self.logger.error("peerConnection new signaling state -> UNKNOWN")
        }
    }
    
    
}

