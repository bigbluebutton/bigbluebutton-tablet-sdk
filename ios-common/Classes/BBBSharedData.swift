//
//  BBBSharedData.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import ReplayKit
import os

open class BBBSharedData {
    // Logger (these messages are displayed in the console application)
    private static var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BBBSharedData")
    private static var userDefaults:UserDefaults?
    private static var userDefaultsGroup:String?
    
    public enum SharedData {
        public static let broadcastStarted   = "broadcastStarted"                   // Broadcaster -> UI APP
        public static let broadcastPaused    = "broadcastPaused"                    // Broadcaster -> UI APP
        public static let broadcastResumed   = "broadcastResumed"                   // Broadcaster -> UI APP
        public static let broadcastFinished  = "broadcastFinished"                  // Broadcaster -> UI APP
        
        public static let createScreenShareOffer  = "createScreenShareOffer"        // UI APP -> Broadcaster
        public static let screenShareOfferCreated  = "screenShareOfferCreated"      // Broadcaster -> UI APP
        
        public static let setScreenShareRemoteSDP  = "setScreenShareRemoteSDP"                        // UI APP -> Broadcaster
        public static let setScreenShareRemoteSDPCompleted  = "setScreenShareRemoteSDPCompleted"      // Broadcaster -> UI APP
        
        public static let addScreenShareRemoteIceCandidate = "addScreenShareRemoteIceCandidate" // UI APP -> Broadcaster
        public static let addScreenShareRemoteIceCandidateCompleted = "addScreenShareRemoteIceCandidateCompleted" // Broadcaster -> UI APP
        
        public static let onScreenShareLocalIceCandidate  = "onScreenShareLocalIceCandidate"  // Broadcaster -> UI APP
        
        public static let onScreenShareSignalingStateChange = "onScreenShareSignalingStateChange" // Broadcaster -> UI APP
        
        public static let onApplicationTerminated = "onApplicationTerminated" // UI APP -> Broadcaster
        
        public static let onBroadcastStopped = "onBroadcastStopped" // UI APP -> Broadcaster
        
    }
    
    // Get reference to userDefaults object (that's actually the object used to share information among UI APP and the BroadcastUploadExtension APP)
    public static func getUserDefaults(appGroupName:String) -> UserDefaults {
        if(userDefaults == nil || userDefaultsGroup == nil || userDefaultsGroup != appGroupName) {
            logger.info("getUserDefaults \(appGroupName) -> Created")
            userDefaults = UserDefaults.init(suiteName: appGroupName)
            userDefaultsGroup = appGroupName
        } else {
            logger.info("getUserDefaults \(appGroupName) -> Reused")
        }
        
        return userDefaults!
    }
    
    // Generates a unique payload
    public static func generatePayload(properties:Dictionary<String,String> = [:]) -> String {
        let now=String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short));
        
        var payload = properties;
        payload["uuid"] = UUID().uuidString;
        payload["timestamp"] = now;
        
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(payload) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON = \(jsonString)")
                return jsonString
            }
        }
        
        logger.error("JSON encoder error, returning empty object")
        return "{}";
    }
}
