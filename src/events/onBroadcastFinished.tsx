import type { MutableRefObject } from 'react';
import type { EmitterSubscription } from 'react-native';
import nativeEmitter from '../native-messaging/emitter';

export function setupListener(
  _webViewRef: MutableRefObject<any>
): EmitterSubscription {
  // Resolve promise when SDP offer is available
  return nativeEmitter.addListener('onBroadcastFinished', () => {
    console.log(`Broadcast finished`);
    _webViewRef.current.injectJavaScript(
      `window.bbbMobileScreenShareBroadcastFinishedCallback && window.bbbMobileScreenShareBroadcastFinishedCallback();`
    );
  });
}
