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

        self.activeAudioSession(bool: true)
        
        let path = Bundle.main.path(forResource: "music2", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        
        print("audioUrl2 = \(url)")
        do {
            
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.play()
            self.playSoundInLoop()
        }
        catch {
            logger.error("Error to play audio = \(url)")
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
    
    func activeAudioSession(bool BoolToActive: Bool){
        do{
            try audioSession.setActive(BoolToActive)
        }catch{
            logger.error("Error to change status of audioSession")
        }
    }
    
    //This method prevents the sound that keeps the app active in the background
    func playSoundInLoop(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3000) {
            self.logger.info("restarting music")
            self.player.currentTime = 0.1;
            self.playSoundInLoop()//recursive call
        }
        
    }
    
}

