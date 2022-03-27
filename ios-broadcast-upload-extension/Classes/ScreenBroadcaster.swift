//
//  ScreenBroadcaster.swift
//
//  Created by Tiago Daniel Jacobs on 27/03/22.
//
import os
import bigbluebutton_mobile_sdk_common

open class ScreenBroadcaster {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "ScreenBroadcaster")
    private var webRTCClient:WebRTCClient
    
    init() {
        webRTCClient = WebRTCClient(iceServers: ["stun:stun.l.google.com:19302",
                                     "stun:stun1.l.google.com:19302",
                                     "stun:stun2.l.google.com:19302",
                                     "stun:stun3.l.google.com:19302",
                                     "stun:stun4.l.google.com:19302"])
    }

    public func createOffer() async -> String? {
        do{
            let rtcSessionDescription = try await self.webRTCClient.offer()
            return rtcSessionDescription.sdp
        } catch {
            logger.error("Error on webRTCClient.offer")
            return nil
        }
    }
    
    public func setRemoteSDP(remoteSDP:String) async -> Bool  {
        do {
            try await self.webRTCClient.setRemoteSDP(remoteSDP: remoteSDP)
            return true
        }
        catch {
            return false
        }
    }
    
    
}
