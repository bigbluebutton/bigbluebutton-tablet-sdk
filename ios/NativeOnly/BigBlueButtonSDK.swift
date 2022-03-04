//
//  BigBlueButton.swift
//  bigbluebutton-mobile-sdk
//
//  Created by Tiago Daniel Jacobs on 03/03/22.
//

import Foundation
import os

open class BigBlueButtonSDK: NSObject {
    // Logger (these messages are displayed in the console application)
    private static var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BigBlueButton")
    private static var broadcastExtensionBundleId = ""
    private static var appGroupName = ""
    
    
    public static func initialize(broadcastExtensionBundleId:String, appGroupName:String) {
        self.broadcastExtensionBundleId = broadcastExtensionBundleId
        self.appGroupName = appGroupName
        
        // BBBSharedData.getUserDefaults(appGroupName: appGroupName)
    }
    
    public static func getBroadcastExtensionBundleId() -> String {
        return self.broadcastExtensionBundleId;
    }
}
