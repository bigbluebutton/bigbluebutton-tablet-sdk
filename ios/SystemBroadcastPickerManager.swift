import ReplayKit
import os

@objc(SystemBroadcastPickerManager)
class SystemBroadcastPickerManager: RCTViewManager {
    @objc var broadcastAppBundleId: String = ""
    
    override func view() -> (SystemBroadcastPicker) {
        let picker = SystemBroadcastPicker();
        picker.setBroadcastAppBundleId(newBroadcastAppBundleId: broadcastAppBundleId);
        return picker;
    }
}

class SystemBroadcastPicker : UIView {
    private var broadcastPicker: RPSystemBroadcastPickerView?
    public var broadcastAppBundleId: String = ""
    
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
        // logger.info("Initializing SystemBroadcastPickerManager, broadcastAppBundleId: \(self.broadcastAppBundleId)")
        let logger = Logger()
        logger.info("OI!")
        let pickerFrame = CGRect(x: 100, y: 100, width: 80, height: 80)
        broadcastPicker = RPSystemBroadcastPickerView(frame: pickerFrame)
        broadcastPicker?.preferredExtension = self.broadcastAppBundleId
        self.addSubview(broadcastPicker!)
    }
    
    @objc(setBroadcastAppBundleId:)
    public func setBroadcastAppBundleId(newBroadcastAppBundleId: String) {
        self.broadcastAppBundleId = newBroadcastAppBundleId
    }
}
