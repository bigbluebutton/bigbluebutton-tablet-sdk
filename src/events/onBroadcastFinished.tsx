import type { MutableRefObject } from 'react';
import nativeEmitter from '../native-messaging/emitter';

export function setupListener(_webViewRef: MutableRefObject<any>) {
  // Resolve promise when SDP offer is available
  nativeEmitter.addListener('onBroadcastFinished', () => {
    console.log(`Broadcast finished`);
    _webViewRef.current.injectJavaScript(
      `window.bbbMobileScreenShareBroadcastFinishedCallback && window.bbbMobileScreenShareBroadcastFinishedCallback();`
    );
  });
}
