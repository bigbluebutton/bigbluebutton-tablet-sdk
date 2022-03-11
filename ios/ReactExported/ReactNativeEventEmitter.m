//
//  ReactNativeEventEmitter.m
//
//  Created by Tiago Daniel Jacobs on 11/03/22.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ReactNativeEventEmitter, RCTEventEmitter)

RCT_EXTERN_METHOD(supportedEvents)

@end
