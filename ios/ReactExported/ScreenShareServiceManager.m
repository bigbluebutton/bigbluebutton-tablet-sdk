//
//  ScreenShareServiceManager.m
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
@interface RCT_EXTERN_REMAP_MODULE(BBBN_ScreenShareService, ScreenShareServiceManager, NSObject)

RCT_EXTERN_METHOD(stopScreenShareBroadcastExtension)
RCT_EXTERN_METHOD(initializeScreenShare)
RCT_EXTERN_METHOD(createScreenShareOffer: (NSString *)stunTurnJson)
RCT_EXTERN_METHOD(setScreenShareRemoteSDP: (NSString *)remoteSDP)
RCT_EXTERN_METHOD(addScreenShareRemoteIceCandidate: (NSString *)remoteCandidate)

+ (BOOL)requiresMainQueueSetup { return NO; }

@end
