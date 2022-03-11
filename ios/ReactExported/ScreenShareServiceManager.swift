//
//  ScreenShareServiceManager.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import Foundation
import os

@objc(ScreenShareServiceManager)
class ScreenShareServiceManager: NSObject {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "ScreenShareServiceManager")
    
    // React native exposed method (called when user click the button to share screen)
    @objc func initializeScreenShare() -> Void {
        logger.info("initializeScreenShare")
        
        // Request the system broadcast
        logger.info("initializeScreenShare - requesting broadcast")
        SystemBroadcastPicker.requestBroadcast()
        
        let eventName = ReactNativeEventEmitter.EVENT.onBroadcastRequested.rawValue
        logger.info("initializeScreenShare - emitting event \(eventName)")
        ReactNativeEventEmitter.emitter.sendEvent(withName: eventName, body: nil);
    }
    
}
