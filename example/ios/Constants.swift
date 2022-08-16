//
//  Constants.swift
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

import Foundation

class Constants {
  // This is used to filter the list of broadcast applications offered to the user (it must match with bundle id of the broadcast extension target)
  public static var broadcastExtensionBundleId="org.bigbluebutton.tablet.sdk.example.03DE7B1E.BigBlueButtonTabletSdkBroadcastExample";
  
  // This is used to allow both applications (main and broadcast) to share information
  public static var appGroupName="group.corg.bigbluebutton.tablet";
  
}
