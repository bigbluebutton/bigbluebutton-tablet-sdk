import Foundation
import os

@objc(ScreenShareServiceManager)
class ScreenShareServiceManager: NSObject {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "ScreenShareServiceManager")
    private var initializeScreenShareResolve:RCTPromiseResolveBlock?
    @objc private var initializeScreenShareReject:RCTPromiseRejectBlock?
    
    // React native exposed method (called when user click the button to share screen)
    @objc func initializeScreenShare(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
        logger.info("initializeScreenShare")
        
        // Store the promise resolve/reject functions
        self.initializeScreenShareResolve = resolve
        self.initializeScreenShareReject = reject
        
        // Request the system broadcast
        SystemBroadcastPicker.requestBroadcast()
        
        // TODO for Milan - Setup KVO observer to call resolve or reject ( based on the result of broadcast attempt )
        
        
        // Examples of when it must reject:
        //   - User canceled the broadcast (clicked outside of the popup)
        //   - User no answer was received after 10 seconds
        
        /*
         THIS IS AN EXAMPLE of how to reject:
         
         let error = NSError(domain: "", code: 200, userInfo: nil)
         initializeScreenShareReject!("ERROR_FOUND", "failure", error)
        */
        
        
        // Examples of when it must resolve:
        //   - Broadcast upload extension received the broadcastStarted event
        
        // THIS IS AN EXAMPLE of how to resolve:
        initializeScreenShareResolve!(nil)
    }
}
