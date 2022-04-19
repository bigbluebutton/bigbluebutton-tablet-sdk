import type { MutableRefObject } from 'react';
import nativeEmitter from '../native-messaging/emitter';

export function setupListener(_webViewRef: MutableRefObject<any>) {
  // Resolve promise when SDP offer is available
  nativeEmitter.addListener(
    'onScreenShareLocalIceCandidate',
    (jsonEncodedIceCandidate) => {
      let iceCandidate = JSON.parse(jsonEncodedIceCandidate);
      if (typeof iceCandidate == 'string') {
        iceCandidate = JSON.parse(iceCandidate);
      }
      const event = { candidate: iceCandidate };
      _webViewRef.current.injectJavaScript(
        `window.bbbMobileScreenShareIceCandidateCallback && window.bbbMobileScreenShareIceCandidateCallback(${JSON.stringify(
          event
        )});`
      );
    }
  );
}
