//
//  UserDefaultsExt.swift
//  BigbluebuttonMobileSdkExample
//
//  Created by Milan Bojic on 23.2.22..
//

import Foundation

extension UserDefaults {
    struct Key {
        static let sdpOffer = "sdpOffer"
    }
}

extension UserDefaults {
    @objc dynamic var sdpOffer: String {
      return string(forKey: Key.sdpOffer) ?? ""
    }
}
