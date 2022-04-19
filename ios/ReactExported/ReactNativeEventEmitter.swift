//
//  ReactNativeEventEmitter.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import Foundation
import React

@objc(ReactNativeEventEmitter)
open class ReactNativeEventEmitter: RCTEventEmitter {
    
    public static var emitter: RCTEventEmitter!
    
    public enum EVENT: String, CaseIterable {
        case onBroadcastRequested = "onBroadcastRequested"
        case onBroadcastStarted = "onBroadcastStarted"
        case onBroadcastPaused = "onBroadcastPaused"
        case onBroadcastResumed = "onBroadcastResumed"
        case onBroadcastFinished = "onBroadcastFinished"
        case onScreenShareOfferCreated = "onScreenShareOfferCreated"
        case onSetScreenShareRemoteSDPCompleted = "onSetScreenShareRemoteSDPCompleted"
        case onScreenShareLocalIceCandidate = "onScreenShareLocalIceCandidate"
        case onScreenShareSignalingStateChange = "onScreenShareSignalingStateChange"
        case onAddScreenShareRemoteIceCandidateCompleted = "onAddScreenShareRemoteIceCandidateCompleted"
        case onFullAudioOfferCreated = "onFullAudioOfferCreated"
        case onSetFullAudioRemoteSDPCompleted = "onSetFullAudioRemoteSDPCompleted"
    }
    
    override init() {
        super.init()
        ReactNativeEventEmitter.emitter = self
    }
    
    open override func supportedEvents() -> [String] {
        EVENT.allCases.map { $0.rawValue }
    }
    
    @objc open override class func requiresMainQueueSetup() -> Bool {
        return false
    }
}
