//
//  BigBlueButton.swift
//  bigbluebutton-mobile-sdk
//
//  Created by Tiago Daniel Jacobs on 03/03/22.
//

import Foundation
import os
import AVFAudio
import React
import bigbluebutton_tablet_sdk_common

open class BigBlueButtonSDK: NSObject {
    // Logger (these messages are displayed in the console application)
    private static var logger = os.Logger(subsystem: "BigBlueButtonTabletSDK", category: "BigBlueButton")
    private static var broadcastExtensionBundleId = ""
    private static var appGroupName = ""
    private static var userDefaults:UserDefaults?
    private static var observer1: NSKeyValueObservation?
    private static var observer2: NSKeyValueObservation?
    private static var observer3: NSKeyValueObservation?
    private static var observer4: NSKeyValueObservation?
    private static var observer5: NSKeyValueObservation?
    private static var observer6: NSKeyValueObservation?
    private static var observer7: NSKeyValueObservation?
    
    public static func initialize(broadcastExtensionBundleId:String, appGroupName:String) {
        self.broadcastExtensionBundleId = broadcastExtensionBundleId
        self.appGroupName = appGroupName
        
        userDefaults = BBBSharedData.getUserDefaults(appGroupName: appGroupName)
        
        // Observe keys modified by BroadcastUploadExtension and emit this event to react native
        
        //broadcastStarted
        observer1 = userDefaults?.observe(\.broadcastStarted, options: [.new]) { (defaults, change) in
            logger.info("Detected a change in userDefaults for key broadcastStarted")
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onBroadcastStarted.rawValue, body: nil)
        }
        
        //screenShareOfferCreated
        observer2 = userDefaults?.observe(\.screenShareOfferCreated, options: [.new]) { (defaults, change) in
            let payload:String = (change.newValue!);
            logger.info("Detected a change in userDefaults for key screenShareOfferCreated \(payload)")
            let payloadData = payload.data(using: .utf8)!
            
            let decodedPayload = (try? JSONDecoder().decode([String: String].self, from: payloadData))!
            let sdp = decodedPayload["sdp"]
            
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onScreenShareOfferCreated.rawValue, body: sdp)
        }
        
        //setScreenShareRemoteSDPCompleted
        observer3 = userDefaults?.observe(\.setScreenShareRemoteSDPCompleted, options: [.new]) { (defaults, change) in
            logger.info("Detected a change in userDefaults for key setScreenShareRemoteSDPCompleted")
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onSetScreenShareRemoteSDPCompleted.rawValue, body: nil)
        }
        
        //setScreenShareRemoteSDPCompleted
        observer4 = userDefaults?.observe(\.onScreenShareLocalIceCandidate, options: [.new]) { (defaults, change) in
            let payload:String = (change.newValue!);
            logger.info("Detected a change in userDefaults for key onScreenShareLocalIceCandidate \(payload)")
            let payloadData = payload.data(using: .utf8)!
            
            let decodedPayload = (try? JSONDecoder().decode([String: String].self, from: payloadData))!
            let iceJson = decodedPayload["iceJson"]
            
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onScreenShareLocalIceCandidate.rawValue, body: iceJson)
        }
        
        
        //onScreenShareSignalingStateChange
        observer5 = userDefaults?.observe(\.onScreenShareSignalingStateChange, options: [.new]) { (defaults, change) in
            let payload:String = (change.newValue!);
            logger.info("Detected a change in userDefaults for key onScreenShareSignalingStateChange \(payload)")
            let payloadData = payload.data(using: .utf8)!

            let decodedPayload = (try? JSONDecoder().decode([String: String].self, from: payloadData))!
            let newState = decodedPayload["newState"]
            
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onScreenShareSignalingStateChange.rawValue, body: newState)
        }
        
        //addScreenShareRemoteIceCandidateCompleted
        observer6 = userDefaults?.observe(\.addScreenShareRemoteIceCandidateCompleted, options: [.new]) { (defaults, change) in
            logger.info("Detected a change in userDefaults for key addScreenShareRemoteIceCandidateCompleted")
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onAddScreenShareRemoteIceCandidateCompleted.rawValue, body: nil)
        }
        
        //addScreenShareRemoteIceCandidateCompleted
        observer7 = userDefaults?.observe(\.broadcastFinished, options: [.new]) { (defaults, change) in
            logger.info("Detected a change in userDefaults for key broadcastFinished")
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onBroadcastFinished.rawValue, body: nil)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            try AVAudioSession.sharedInstance().setPrefersNoInterruptionsFromSystemAlerts(true)
        } catch let error {
            logger.error("Error configuring audio session \(error.localizedDescription)")
        }
    }
    
    public static func getBroadcastExtensionBundleId() -> String {
        return self.broadcastExtensionBundleId;
    }
    
    public static func getAppGroupName() -> String {
        return self.appGroupName;
    }
    
    public static func deinitialize () {
        observer1?.invalidate()
        observer2?.invalidate()
    }
    
    public static func onAppTerminated(){
        logger.info("onAppTerminated called")
        BBBSharedData
            .getUserDefaults(appGroupName: self.appGroupName)
            .set(BBBSharedData.generatePayload(), forKey: BBBSharedData.SharedData.onApplicationTerminated)
    }
    
    public static func handleDeepLink(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]){
        RCTLinkingManager.application(app, open: url, options: options)
    }

}
