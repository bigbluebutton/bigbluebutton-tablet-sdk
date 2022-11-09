//
//  FullAudioServiceManager.m
//
//  Created by Tiago Daniel Jacobs on 20/04/22.
//

#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
@interface RCT_EXTERN_REMAP_MODULE(BBBN_FullAudioService, FullAudioServiceManager, NSObject)

RCT_EXTERN_METHOD(createFullAudioOffer: (NSString *)stunTurnJson)
RCT_EXTERN_METHOD(setFullAudioRemoteSDP: (NSString *)remoteSDP)
RCT_EXTERN_METHOD(addFullAudioRemoteIceCandidate: (NSString *)remoteCandidate)

+ (BOOL)requiresMainQueueSetup { return NO; }

@end
