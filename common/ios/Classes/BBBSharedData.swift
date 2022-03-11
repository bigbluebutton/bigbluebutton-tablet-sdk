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
        public static let broadcastStarted   = "broadcastStarted"
        public static let broadcastPaused    = "broadcastPaused"
        public static let broadcastResumed   = "broadcastResumed"
        public static let broadcastFinished  = "broadcastFinished"
    }
    
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
    public static func generatePayload() -> String {
        // TODO - replace by UUID
        let now=String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short));
        
        return "{\"timestamp\": \(now)}";
    }
}
