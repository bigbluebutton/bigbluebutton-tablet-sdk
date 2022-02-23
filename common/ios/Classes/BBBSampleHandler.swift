import ReplayKit
import os

open class BBBSampleHandler : RPBroadcastSampleHandler {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BBBSampleHandler")
    private let defaults = UserDefaults.init(suiteName: "group.com.zuehlke.bbb")
    
    open override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        logger.info("ReplayKit2 event - broadcastStarted")
        defaults!.set("Broadcast started", forKey: "sdpOffer")
    }
    
    open override func broadcastPaused() {
        logger.info("ReplayKit2 event - broadcastPaused")
    }
    
    open override func broadcastResumed() {
        logger.info("ReplayKit2 event - broadcastResumed")
    }
    
    open override func broadcastFinished() {
        logger.info("ReplayKit2 event - broadcastFinished")
        defaults!.set("Broadcast finished", forKey: "sdpOffer")
    }
    
    open override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            logger.trace("ReplayKit2 event - processSampleBuffer(video)")
            defaults!.set("Received video frame", forKey: "sdpOffer")
            break
        case RPSampleBufferType.audioApp:
            logger.trace("ReplayKit2 event - processSampleBuffer(audioApp)")
            break
        case RPSampleBufferType.audioMic:
            logger.trace("ReplayKit2 event - processSampleBuffer(audioMic)")
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
}
