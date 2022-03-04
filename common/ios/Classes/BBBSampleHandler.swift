import ReplayKit
import os

open class BBBSampleHandler : RPBroadcastSampleHandler {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BBBSampleHandler")
    private var appGroupName:String = "";
    
    open func setAppGroupName(appGroupName:String) {
        self.appGroupName = appGroupName;
    }
    
    open override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        logger.info("ReplayKit2 event - broadcastStarted")
    }
    
    open override func broadcastPaused() {
        logger.info("ReplayKit2 event - broadcastPaused")
    }
    
    open override func broadcastResumed() {
        logger.info("ReplayKit2 event - broadcastResumed")
    }
    
    open override func broadcastFinished() {
        logger.info("ReplayKit2 event - broadcastFinished")
    }
    
    open override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            logger.trace("ReplayKit2 event - processSampleBuffer(video)")
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
