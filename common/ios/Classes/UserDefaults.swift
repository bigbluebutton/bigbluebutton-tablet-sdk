//
//  UserDefaults.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

extension UserDefaults {

    @objc open dynamic var broadcastStarted: String {
        return string(forKey: BBBSharedData.SharedData.broadcastStarted) ?? ""
    }
    
    @objc open dynamic var broadcastPaused: String {
        return string(forKey: BBBSharedData.SharedData.broadcastPaused) ?? ""
    }
    
    @objc open dynamic var broadcastResumed: String {
        return string(forKey: BBBSharedData.SharedData.broadcastResumed) ?? ""
    }
    
    @objc open dynamic var broadcastFinished: String {
        return string(forKey: BBBSharedData.SharedData.broadcastFinished) ?? ""
    }

}
