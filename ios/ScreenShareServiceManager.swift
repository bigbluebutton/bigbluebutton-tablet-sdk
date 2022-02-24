import Foundation
import os

@objc(ScreenShareServiceManager)
class ScreenShareServiceManager: NSObject {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "ScreenShareServiceManager")
    
    private var initializeScreenShareResolve:RCTPromiseResolveBlock?
    @objc private var initializeScreenShareReject:RCTPromiseRejectBlock?
    
    private let defaults = UserDefaults.init(suiteName: Constants.appGroup)
    private var sdpOfferObserver: NSKeyValueObservation?
    private var receivedSdpOffer = false
    
    private var timeCounter = 0
    private var timeLimit = 5

    // React native exposed method (called when user click the button to share screen)
    @objc func initializeScreenShare(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
        logger.info("initializeScreenShare")
        
        // Store the promise resolve/reject functions
        self.initializeScreenShareResolve = resolve
        self.initializeScreenShareReject = reject
        
        // Request the system broadcast and setup observer for sdpOffer
        SystemBroadcastPicker.requestBroadcast()
        setupUserDefaultsObserver()
        
        // Cancel broadcast if no user response after 5 seconds
        while timeCounter < timeLimit {
            sleep(1)
            timeCounter += 1
        }
        
        if !receivedSdpOffer {
            let error = NSError(domain: "", code: 200, userInfo: nil)
            self.initializeScreenShareReject!("ERROR_FOUND", "failure", error)
        }
    }
    
    private func setupUserDefaultsObserver() {
        sdpOfferObserver = defaults?.observe(\.sdpOffer, options: [.new]) { [weak self] (defaults, change) in
            guard let `self` = self, let sdpOffer = change.newValue else { return }
            print("SDP Offer: \(sdpOffer)")
            self.receivedSdpOffer = true
            self.initializeScreenShareResolve!(nil)
        }
    }
}
