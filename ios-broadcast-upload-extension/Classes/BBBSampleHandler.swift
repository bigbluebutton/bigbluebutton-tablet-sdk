//
//  BBBSampleHandler.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import ReplayKit
import os
import bigbluebutton_mobile_sdk_common

open class BBBSampleHandler : RPBroadcastSampleHandler {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BBBSampleHandler")
    private var appGroupName:String = "";
    private var createScreenShareOfferObserver:NSKeyValueObservation?;
    private var setScreenShareRemoteSDPOBserver:NSKeyValueObservation?;
    private var addScreenShareRemoteIceCandidateObserver:NSKeyValueObservation?;
    private var onApplicationTerminatedObserver:NSKeyValueObservation?;
    private var onBroadcastStoppedObserver:NSKeyValueObservation?;
    private var screenBroadcaster:ScreenBroadcasterService?;
    
    open func setAppGroupName(appGroupName:String) {
        logger.info("Received appGroupName: \(appGroupName)")
        self.appGroupName = appGroupName
    }
    
    // Called by IOS when the user authorized to start the broadcast
    open override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        logger.info("ReplayKit2 event - broadcastStarted")

        // Object used to share data
        let userDefaults = BBBSharedData
            .getUserDefaults(appGroupName: self.appGroupName)
        
        // Notify the UI app that the broadcast has been started
        logger.info("ReplayKit2 event - broadcastStarted - persisting information on UserDefaults")
        userDefaults.set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.broadcastStarted)
        
        self.screenBroadcaster = ScreenBroadcasterService(appGroupName: appGroupName)
        
        // Handle quit application to finish broadcast togheter
        logger.info("Configuring observer for finishApplication")
        self.onApplicationTerminatedObserver = userDefaults.observe(\.onApplicationTerminated, options: [.new]) { (defaults, change) in
            self.logger.info("Observer detected a onQuitApplicationWithBroadcastActive request!")
            finishBroadcastGracefully(self)
        }
        
        // Handle click in stop broadcast
        logger.info("Configuring observer for stop broadcast")
        self.onBroadcastStoppedObserver = userDefaults.observe(\.onBroadcastStopped, options: [.new]) { (defaults, change) in
            self.logger.info("Observer detected a onBroadcastStopped request!")
            finishBroadcastGracefully(self)
        }
        
        // Listen for createOffer requests from the UI APP
        logger.info("Configuring observer for createOffer")
        self.createScreenShareOfferObserver = userDefaults.observe(\.createScreenShareOffer, options: [.new]) { (defaults, change) in
            self.logger.info("Observer detected a createScreenShareOffer request!")
            
            Task.init {
                let optionalSdp = await self.screenBroadcaster?.createOffer()
                if(optionalSdp != nil){
                    let sdp = optionalSdp!
                    self.logger.info("Got SDP back from screenBroadcaster: \(sdp)")
                    BBBSharedData
                        .getUserDefaults(appGroupName: self.appGroupName)
                        .set(BBBSharedData.generatePayload(properties: [
                            "sdp": sdp
                        ]), forKey: BBBSharedData.SharedData.screenShareOfferCreated)
                }
            }
        }
        
        logger.info("Configuring observer for setRemoteSDP")
        self.setScreenShareRemoteSDPOBserver = userDefaults.observe(\.setScreenShareRemoteSDP, options: [.new]) { (defaults, change) in
            let payload:String = (change.newValue!);
            // self.logger.info("Observer detected a setScreenShareRemoteSDP request with payload \(payload)")
            self.logger.info("Observer detected a setScreenShareRemoteSDP request")
            let payloadData = payload.data(using: .utf8)!
            let decodedPayload = (try? JSONDecoder().decode([String: String].self, from: payloadData))!
            let sdp = decodedPayload["sdp"]
            
            Task.init {
                let remoteSDPDefined = await self.screenBroadcaster!.setRemoteSDP(remoteSDP: sdp!)

                if(remoteSDPDefined){
                    self.logger.info("Remote SDP defined!")
                    BBBSharedData
                        .getUserDefaults(appGroupName: self.appGroupName)
                        .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.setScreenShareRemoteSDPCompleted)
                }
            }
        }
        
        logger.info("Configuring observer for addScreenShareRemoteIceCandidate")
        self.addScreenShareRemoteIceCandidateObserver = userDefaults.observe(\.addScreenShareRemoteIceCandidate, options: [.new]) { (defaults, change) in
            let payload:String = (change.newValue!);
            // self.logger.info("Observer detected a addScreenShareRemoteIceCandidate request with payload \(payload)")
            self.logger.info("Observer detected a addScreenShareRemoteIceCandidate request")
            let payloadData = payload.data(using: .utf8)!
            let decodedPayload = (try? JSONDecoder().decode([String: String].self, from: payloadData))!
            let candidateAsString = decodedPayload["candidate"]!
            let candidateAsData = candidateAsString.data(using: .utf8)!
            let candidate = (try? JSONDecoder().decode(IceCandidate.self, from: candidateAsData))
            
            Task.init {
                let remoteCandidateAdded = await self.screenBroadcaster!.addRemoteCandidate(remoteCandidate: candidate!)

                if(remoteCandidateAdded){
                    self.logger.info("Remote candidate added!")
                    BBBSharedData
                        .getUserDefaults(appGroupName: self.appGroupName)
                        .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.addScreenShareRemoteIceCandidateCompleted)
                }
            }
        }
    }
    
    open override func broadcastPaused() {
        logger.info("ReplayKit2 event - broadcastPaused")
        
        logger.info("ReplayKit2 event - broadcastPaused - persisting information on UserDefaults")
        BBBSharedData
            .getUserDefaults(appGroupName: self.appGroupName)
            .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.broadcastPaused)
    }
    
    open override func broadcastResumed() {
        logger.info("ReplayKit2 event - broadcastResumed")
        
        logger.info("ReplayKit2 event - broadcastResumed - persisting information on UserDefaults")
        BBBSharedData
            .getUserDefaults(appGroupName: self.appGroupName)
            .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.broadcastResumed)
    }
    
    open override func broadcastFinished() {
        logger.info("ReplayKit2 event - broadcastFinished")
        
        logger.info("ReplayKit2 event - broadcastFinished - persisting information on UserDefaults")
        BBBSharedData
            .getUserDefaults(appGroupName: self.appGroupName)
            .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.broadcastFinished)
    }
    
    open override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            logger.trace("ReplayKit2 event - processSampleBuffer(video)")
            self.screenBroadcaster?.pushVideoFrame(sampleBuffer: sampleBuffer)
            break
        case RPSampleBufferType.audioApp:
            logger.trace("ReplayKit2 event - processSampleBuffer(audioApp)")
            break
        case RPSampleBufferType.audioMic:
            logger.trace("ReplayKit2 event - processSampleBuffer(audioMic)")
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
}
