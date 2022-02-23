//
//  AppDelegate.swift
//  BigbluebuttonMobileSdkExample
//
//  Created by Milan Bojic on 23.2.22..
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCTBridgeDelegate {
  
  var window: UIWindow?
  var bridge: RCTBridge!
  
  private let defaults = UserDefaults.init(suiteName: "group.com.zuehlke.bbb")
  private var sdpOfferObserver: NSKeyValueObservation?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
    let rootView = RCTRootView(bridge: bridge, moduleName: "BigbluebuttonMobileSdkExample", initialProperties: nil)
    let rootViewController = UIViewController()
    rootViewController.view = rootView
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = rootViewController
    self.window?.makeKeyAndVisible()
    
    setupUserDefaultsObserver()
    
    return true
  }
  
  func sourceURL(for bridge: RCTBridge!) -> URL! {
//#if DEBUG
    return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource:nil)
//#else
//    let mainBundle = Bundle.main
//    return mainBundle.url(forResource: "main", withExtension: "jsbundle")!
//#endif
  }
  
  private func setupUserDefaultsObserver() {
    sdpOfferObserver = defaults?.observe(\.sdpOffer, options: [.new]) { (defaults, change) in // watch for [weak self]
      guard let sdpOffer = change.newValue else { return }
      print("SDP OFFER RECEIVED: \(sdpOffer)")
    }
  }
}
