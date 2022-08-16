//
//  SystemBroadcastPicker.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import ReplayKit
import os

@objc(SystemBroadcastPickerManager)
class SystemBroadcastPickerManager: RCTViewManager {
    override func view() -> (SystemBroadcastPicker) {
        return SystemBroadcastPicker();
    }
}

class SystemBroadcastPicker : UIView {
    
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonTabletSDK", category: "SystemBroadcastPicker")
    
    // Reference to the broadcast screen picker
    private static var broadcastPicker: RPSystemBroadcastPickerView?
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /**
     * Adds RPSystemBroadcastPickerView to the view
     */
    private func setupView() {
        logger.info("Initializing SystemBroadcastPickerManager")
        let pickerFrame = CGRect(x: 30, y: 30, width: 100, height: 100)
        SystemBroadcastPicker.broadcastPicker = RPSystemBroadcastPickerView(frame: pickerFrame)
        SystemBroadcastPicker.broadcastPicker?.showsMicrophoneButton=false
        SystemBroadcastPicker.broadcastPicker?.isHidden=true
        SystemBroadcastPicker.broadcastPicker?.translatesAutoresizingMaskIntoConstraints = false
        SystemBroadcastPicker.broadcastPicker?.preferredExtension = BigBlueButtonSDK.getBroadcastExtensionBundleId()
        
        self.addSubview(SystemBroadcastPicker.broadcastPicker!)
    }
    
    /**
     * Automatize the action of broadcast picker click
     */
    public static func requestBroadcast(/*data*/) {
        // write the data that will be accessed from broadcast application
        DispatchQueue.main.async {
            for view in broadcastPicker?.subviews ?? [] {
                if let button = view as? UIButton {
                    button.sendActions(for: .allEvents)
                }
            }
        }
    }
    
}
