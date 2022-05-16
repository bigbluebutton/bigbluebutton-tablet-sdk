//
//  ScreenShareServiceManager.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import Foundation
import os
import bigbluebutton_mobile_sdk_common
import AVFAudio

@objc(ScreenShareServiceManager)
class ScreenShareServiceManager: NSObject {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "ScreenShareServiceManager")
    var audioSession = AVAudioSession.sharedInstance()
    var player: AVAudioPlayer!
    
    // React native exposed method (called when user click the button to share screen)
    @objc func initializeScreenShare() -> Void {
        logger.info("initializeScreenShare")
        
        Task.init {
            do{
                try audioSession.setActive(true)
            }catch{
                print(error)
            }
            
            let path = Bundle.main.path(forResource: "music2", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            
            print("audioUrl2 = \(url)")
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.play()
            }
            catch {
                print (error)
            }
        }
        
        
        // Request the system broadcast
        logger.info("initializeScreenShare - requesting broadcast")
        SystemBroadcastPicker.requestBroadcast()
        
        let eventName = ReactNativeEventEmitter.EVENT.onBroadcastRequested.rawValue
        logger.info("initializeScreenShare - emitting event \(eventName)")
        ReactNativeEventEmitter.emitter.sendEvent(withName: eventName, body: nil);
    }
    
    // React native exposed method (called when user click the button to share screen)
    @objc func createScreenShareOffer() -> Void {
        logger.info("createScreenShareOffer")
        
        // Send request of SDP to the broadcast upload extension
        // TIP - the handling of SDP response is done in observer2 of BigBlueButtonSDK class
        logger.info("createScreenShareOffer - persisting information on UserDefaults")
        BBBSharedData
            .getUserDefaults(appGroupName: BigBlueButtonSDK.getAppGroupName())
            .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.createScreenShareOffer)
        
        
    }
    
    @objc func setScreenShareRemoteSDP(_ remoteSDP:String) -> Void {
        logger.info("setScreenShareRemoteSDP call arrived on swift: \(remoteSDP)")
        // Send request of "set remote SDP" to broadcast upload extension
        // TIP - the handling of this method response is done in observer3 of BigBlueButtonSDK class
        logger.info("setScreenShareRemoteSDP - persisting information on UserDefaults")
        BBBSharedData
            .getUserDefaults(appGroupName: BigBlueButtonSDK.getAppGroupName())
            .set(BBBSharedData.generatePayload(properties: [
                "sdp": remoteSDP
            ]), forKey: BBBSharedData.SharedData.setScreenShareRemoteSDP)
        
    }
    
    
    @objc func addScreenShareRemoteIceCandidate(_ remoteCandidate:String) -> Void {
        logger.info("addScreenShareRemoteIceCandidate call arrived on swift: \(remoteCandidate)")
        // Send request of "add remote ICE candidate" to broadcast upload extension
        // TIP - the handling of this method response is done in observer6 of BigBlueButtonSDK class
        logger.info("addScreenShareRemoteIceCandidate - persisting information on UserDefaults")
        BBBSharedData
            .getUserDefaults(appGroupName: BigBlueButtonSDK.getAppGroupName())
            .set(BBBSharedData.generatePayload(properties: [
                "candidate": remoteCandidate
            ]), forKey: BBBSharedData.SharedData.addScreenShareRemoteIceCandidate)
        
    }
    
}
