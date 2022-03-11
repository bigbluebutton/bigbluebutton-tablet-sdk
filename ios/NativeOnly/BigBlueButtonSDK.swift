//
//  BigBlueButton.swift
//  bigbluebutton-mobile-sdk
//
//  Created by Tiago Daniel Jacobs on 03/03/22.
//

import Foundation
import os
import bigbluebutton_mobile_sdk_common

open class BigBlueButtonSDK: NSObject {
    // Logger (these messages are displayed in the console application)
    private static var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BigBlueButton")
    private static var broadcastExtensionBundleId = ""
    private static var appGroupName = ""
    private static var userDefaults:UserDefaults?
    private static var observer: NSKeyValueObservation?
    
    public static func initialize(broadcastExtensionBundleId:String, appGroupName:String) {
        self.broadcastExtensionBundleId = broadcastExtensionBundleId
        self.appGroupName = appGroupName
        
        userDefaults = BBBSharedData.getUserDefaults(appGroupName: appGroupName)
        
        // Observe keys modified by BroadcastUploadExtension and emit this event to react native
        
        //broadcastStarted
        observer = userDefaults?.observe(\.broadcastStarted, options: [.new]) { (defaults, change) in
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onBroadcastStarted.rawValue, body: nil)
        }
        
        
    }
    
    public static func getBroadcastExtensionBundleId() -> String {
        return self.broadcastExtensionBundleId;
    }
    
    public static func deinitialize () {
        observer?.invalidate()
    }

}
