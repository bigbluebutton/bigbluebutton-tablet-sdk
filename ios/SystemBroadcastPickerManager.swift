import ReplayKit

@available(iOS 12.0, *)
@objc(SystemBroadcastPickerManager)
class SystemBroadcastPickerManager: RCTViewManager {

  override func view() -> (SystemBroadcastPicker) {
    return SystemBroadcastPicker()
  }
}

@available(iOS 12.0, *)
class SystemBroadcastPicker : UIView {
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
        let pickerFrame = CGRect(x: 100, y: 100, width: 80, height: 80)
        broadcastPicker = RPSystemBroadcastPickerView(frame: pickerFrame)
        broadcastPicker?.preferredExtension = "org.bigbluebutton.mobile.BigBlueButton.BroadcastUpload"
        self.addSubview(broadcastPicker!)
    }
}
