import type { MutableRefObject } from 'react';
import nativeEmitter from '../native-messaging/emitter';

export function setupListener(_webViewRef: MutableRefObject<any>) {
  // Resolve promise when SDP offer is available
  nativeEmitter.addListener(
    'onScreenShareLocalIceCandidate',
    (jsonEncodedIceCandidate) => {
      const iceCandidate = JSON.parse(jsonEncodedIceCandidate);
      _webViewRef.current.injectJavaScript(
        `window.bbbMobileScreenShareIceCandidateCallback(${JSON.stringify(
          iceCandidate
        )});`
      );
    }
  );
}
