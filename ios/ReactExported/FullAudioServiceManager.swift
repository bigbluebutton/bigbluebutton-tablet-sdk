//
//  FullAudioServiceManager.swift
//
//  Created by Tiago Daniel Jacobs on 20/04/22.
//

import Foundation
import os
import bigbluebutton_tablet_sdk_common
import AVFAudio

@objc(FullAudioServiceManager)
class FullAudioServiceManager: NSObject {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonTabletSDK", category: "FullAudioServiceManager")
    var audioSession = AVAudioSession.sharedInstance()
    var player: AVAudioPlayer!
    var fullAudioService: FullAudioService = FullAudioService( )
    
    // React native exposed method (called when user click the button to share screen)
    @objc func createFullAudioOffer(_ stunTurnJson:String) -> Void {
        logger.info("createFullAudioOffer \(stunTurnJson)")
        Task.init {
            let optionalSdp = await self.fullAudioService.createOffer()
            if(optionalSdp != nil){
                let sdp = optionalSdp!
                self.logger.info("Got SDP back from fullAudioService: \(sdp)")
                ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onFullAudioOfferCreated.rawValue, body: sdp)
            }
        }
        
    }
    
    @objc func setFullAudioRemoteSDP(_ remoteSDP:String) -> Void {
        logger.info("setFullAudioRemoteSDP call arrived on swift: \(remoteSDP)")

        Task.init {
            let setRemoteSDPAnswer = await self.fullAudioService.setRemoteSDP(remoteSDP: remoteSDP);
            self.logger.info("Got \(setRemoteSDPAnswer) back from setRemoteSDP")
            ReactNativeEventEmitter.emitter.sendEvent(withName: ReactNativeEventEmitter.EVENT.onSetFullAudioRemoteSDPCompleted.rawValue, body: nil)
        }
    }


    @objc func addFullAudioRemoteIceCandidate(_ remoteCandidate:String) -> Void {
        logger.info("!! NOT IMPLEMENTED !! addFullAudioRemoteIceCandidate call arrived on swift: \(remoteCandidate)")
    }
    
}
