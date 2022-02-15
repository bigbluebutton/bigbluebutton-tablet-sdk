#import "React/RCTViewManager.h"

@interface RCT_EXTERN_REMAP_MODULE(BBBN_SystemBroadcastPicker, SystemBroadcastPickerManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(broadcastAppBundleId, NSString)

+ (BOOL)requiresMainQueueSetup { return YES; }

@end
