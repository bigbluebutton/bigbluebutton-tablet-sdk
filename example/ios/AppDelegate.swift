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
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
    let rootView = RCTRootView(bridge: bridge, moduleName: "BigbluebuttonMobileSdkExample", initialProperties: nil)
    let rootViewController = UIViewController()
    rootViewController.view = rootView
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = rootViewController
    self.window?.makeKeyAndVisible()
        
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
}
