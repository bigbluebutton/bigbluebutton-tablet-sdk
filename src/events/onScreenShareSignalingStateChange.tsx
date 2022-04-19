import type { MutableRefObject } from 'react';
import nativeEmitter from '../native-messaging/emitter';

export function setupListener(_webViewRef: MutableRefObject<any>) {
  // Resolve promise when SDP offer is available
  nativeEmitter.addListener('onScreenShareSignalingStateChange', (newState) => {
    console.log(`Temos um novo state: ${newState}`);
    _webViewRef.current.injectJavaScript(
      `window.bbbMobileScreenShareSignalingStateChangeCallback && window.bbbMobileScreenShareSignalingStateChangeCallback(${JSON.stringify(
        newState
      )});`
    );
  });
}
