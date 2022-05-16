//
//  SampleHandler.m
//  BigBlueButton Broadcast
//
//  Created by Gustavo Emanuel Farias Rosa on 09/05/22.
//

#import <Foundation/Foundation.h>

#import "FinishBroadcastService.h"

void finishBroadcastGracefully(RPBroadcastSampleHandler * _Nonnull broadcastSampleHandler) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [broadcastSampleHandler finishBroadcastWithError:nil];
#pragma clang diagnostic pop
}
