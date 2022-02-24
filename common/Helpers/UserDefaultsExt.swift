//
//  UserDefaultsExt.swift
//  bigbluebutton-mobile-sdk-common
//
//  Created by Milan Bojic on 23.2.22..
//

import Foundation

extension UserDefaults {
    enum Key {
        static let sdpOffer = "sdpOffer"
        static let broadcastRejected = "broadcastRejected"
    }
}

extension UserDefaults {
    @objc dynamic var sdpOffer: String {
      return string(forKey: Key.sdpOffer) ?? ""
    }
    
    @objc dynamic var broadcastRejected: Bool {
      return bool(forKey: Key.broadcastRejected)
    }
}
