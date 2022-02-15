import ReplayKit
import os

@objc(SystemBroadcastPickerManager)
class SystemBroadcastPickerManager: RCTViewManager {
    override func view() -> (SystemBroadcastPicker) {
        return SystemBroadcastPicker();
    }
}

class SystemBroadcastPicker : UIView {
    
    private var broadcastAppBundleId: String = ""
    
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "SystemBroadcastPicker")
    
    private var broadcastPicker: RPSystemBroadcastPickerView?
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        logger.info("Initializing SystemBroadcastPickerManager (rendering offscreen)")
        let pickerFrame = CGRect(x: 0, y: 50, width: 80, height: 80)
        broadcastPicker = RPSystemBroadcastPickerView(frame: pickerFrame)
        self.addSubview(broadcastPicker!)
    }
    
    @objc(setBroadcastAppBundleId:)
    public func setBroadcastAppBundleId(newBroadcastAppBundleId: String) {
        logger.info("setBroadcastAppBundleId called \(newBroadcastAppBundleId)")
        self.broadcastAppBundleId = newBroadcastAppBundleId
    }
    
    override func didSetProps(_ changedProps: [String]!) {
        logger.info("Defining preferredExtension as \(self.broadcastAppBundleId)")
        broadcastPicker?.preferredExtension = self.broadcastAppBundleId
    }
    
}
