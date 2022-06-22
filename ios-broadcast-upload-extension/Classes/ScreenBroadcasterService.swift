//
//  ScreenBroadcaster.swift
//
//  Created by Tiago Daniel Jacobs on 27/03/22.
//
import os
import bigbluebutton_mobile_sdk_common
import WebRTC
import UIKit

open class ScreenBroadcasterService {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "ScreenBroadcasterService")
    private var webRTCClient:ScreenShareWebRTCClient
    private var appGroupName:String
    private let encoder = JSONEncoder()
    public var isConnected:Bool = false
    
    init(appGroupName: String) {
        self.appGroupName = appGroupName
        
        webRTCClient = ScreenShareWebRTCClient(iceServers: ["stun:stun.l.google.com:19302",
                                     "stun:stun1.l.google.com:19302",
                                     "stun:stun2.l.google.com:19302",
                                     "stun:stun3.l.google.com:19302",
                                     "stun:stun4.l.google.com:19302"])
        webRTCClient.delegate = self
        
       
    }

    public func createOffer() async -> String? {
        do{
            let rtcSessionDescription = try await self.webRTCClient.offer()
            return rtcSessionDescription.sdp
        } catch {
            logger.error("Error on webRTCClient.offer")
            return nil
        }
    }
    
    public func setRemoteSDP(remoteSDP:String) async -> Bool  {
        do {
            try await self.webRTCClient.setRemoteSDP(remoteSDP: remoteSDP)
            return true
        }
        catch {
            return false
        }
    }
    
    public func addRemoteCandidate(remoteCandidate:IceCandidate) async -> Bool  {
        do {
            try await self.webRTCClient.setRemoteCandidate(remoteIceCandidate: remoteCandidate)
            return true
        }
        catch {
            return false
        }
    }
    
    public func pushVideoFrame(sampleBuffer: CMSampleBuffer) -> Void {
        if(!isConnected) {
            self.logger.info("Ignoring pushVideoFrame - not connected")
        } else {
            var rotationFrame: RTCVideoRotation = ._0
            var orientation = CGImagePropertyOrientation.up
           if #available(iOS 11.0, *) {
               if let orientationAttachment = CMGetAttachment(sampleBuffer, key: RPVideoSampleOrientationKey as CFString, attachmentModeOut: nil) as? NSNumber {
                   orientation = CGImagePropertyOrientation(rawValue: orientationAttachment.uint32Value) ?? .up
               }
            }
            
            switch orientation.rawValue {
            case UInt32(6):
                rotationFrame = ._270
            case UInt32(8):
                rotationFrame = ._90
            default:
                rotationFrame = ._0
            }

            self.logger.info("pushing video")
            let imageBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let timeStampNs: Int64 = Int64(CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * 1000000000)
            let rtcPixlBuffer = RTCCVPixelBuffer(pixelBuffer: imageBuffer)
            
            if(!webRTCClient.getIsRatioDefined()) {
                webRTCClient.setRatio(originalWidth: rtcPixlBuffer.width, originalHeight: rtcPixlBuffer.height)
            }
            
            let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixlBuffer, rotation: rotationFrame, timeStampNs: timeStampNs)
            self.webRTCClient.push(videoFrame: rtcVideoFrame)
            self.logger.info("video pushed")
        }
    }
    
}

extension ScreenBroadcasterService: ScreenShareWebRTCClientDelegate {
    
    public func webRTCClient(_ client: ScreenShareWebRTCClient, didDiscoverLocalCandidate rtcIceCandidate: RTCIceCandidate) {
        do {
            let iceCandidate = IceCandidate(from: rtcIceCandidate)
            let iceCandidateAsJsonData = try self.encoder.encode(iceCandidate)
            let iceCandidateAsJsonString = String(decoding: iceCandidateAsJsonData, as: UTF8.self)

            
            BBBSharedData
                .getUserDefaults(appGroupName: self.appGroupName)
                .set(BBBSharedData.generatePayload(properties: [
                    "iceJson": iceCandidateAsJsonString
                ]), forKey: BBBSharedData.SharedData.onScreenShareLocalIceCandidate)
        } catch {
            self.logger.error("Error handling ICE candidate")
        }
    }
    
    public func webRTCClient(_ client: ScreenShareWebRTCClient, didChangeIceConnectionState state: RTCIceConnectionState) {
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
    
    public func webRTCClient(_ client: ScreenShareWebRTCClient, didChangeIceGatheringState state: RTCIceGatheringState) {
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
    
    public func webRTCClient(_ client: ScreenShareWebRTCClient, didChangeSignalingState state: RTCSignalingState) {
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
        
        self.isConnected = true
        
        BBBSharedData
            .getUserDefaults(appGroupName: self.appGroupName)
            .set(BBBSharedData.generatePayload(properties: [
                "newState": stateString
            ]), forKey: BBBSharedData.SharedData.onScreenShareSignalingStateChange)
    }
    
    
}

