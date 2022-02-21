#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
@interface RCT_EXTERN_REMAP_MODULE(BBBN_ScreenShareService, ScreenShareServiceManager, NSObject)

RCT_EXTERN_METHOD(initializeScreenShare: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject)
@end
