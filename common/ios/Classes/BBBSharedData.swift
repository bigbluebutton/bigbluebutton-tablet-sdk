import ReplayKit
import os

open class BBBSharedData {
    // Logger (these messages are displayed in the console application)
    private static var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BBBSharedData")
    
    public static func getUserDefaults(appGroupName:String) /* -> UserDefaults */ {
        logger.info("getUserDefaults \(appGroupName)")
    }
}
