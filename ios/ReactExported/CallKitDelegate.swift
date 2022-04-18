//
//  CallKitDelegate.swift
//  bigbluebutton-mobile-sdk
//
//  Created by Tiago Daniel Jacobs on 18/04/22.
//

import Foundation
import CallKit
import os

class CallKitDelegate : NSObject {
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "CallKitDelegate")
}

extension CallKitDelegate : CXProviderDelegate {
    

    func providerDidReset(_ provider: CXProvider) {
        logger.info("OI1")
        }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
            action.fulfill()
        }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
            action.fulfill()
        }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
            action.fulfill()
        }
    
}
