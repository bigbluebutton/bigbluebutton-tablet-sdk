import type { MutableRefObject } from 'react';
import type { WebView, WebViewMessageEvent } from 'react-native-webview';
import initializeScreenShare from '../methods/initializeScreenShare';
import createScreenShareOffer from '../methods/createScreenShareOffer';
import setScreenShareRemoteSDP from '../methods/setScreenShareRemoteSDP';
import setFullAudioRemoteSDP from '../methods/setFullAudioRemoteSDP';
import addScreenShareRemoteIceCandidate from '../methods/addScreenShareRemoteIceCandidate';
import createFullAudioOffer from '../methods/createFullAudioOffer';

function observePromiseResult(
  webViewRef: MutableRefObject<WebView>,
  sequence: number,
  prom: Promise<any>
) {
  prom
    .then((result: any) => {
      console.log(`Promise ${sequence} resolved!`, result);
      webViewRef.current.injectJavaScript(
        `window.nativeMethodCallResult(${sequence}, true ${
          result ? ',' + JSON.stringify(result) : ''
        });`
      );
    })
    .catch((exception: any) => {
      console.error(`Promise ${sequence} failed!`, exception);
      webViewRef.current.injectJavaScript(
        `window.nativeMethodCallResult(${sequence}, false ${
          exception ? ',' + JSON.stringify(exception) : ''
        });`
      );
    });
}

export function handleWebviewMessage(
  webViewRef: MutableRefObject<any>,
  event: WebViewMessageEvent
) {
  const stringData = event?.nativeEvent?.data;

  const data = JSON.parse(stringData);
  if (data?.method && data?.sequence) {
    let promise;
    switch (data?.method) {
      case 'initializeScreenShare':
        promise = initializeScreenShare();
        break;
      case 'createFullAudioOffer':
        promise = createFullAudioOffer();
        break;
      case 'createScreenShareOffer':
        promise = createScreenShareOffer();
        break;
      case 'setScreenShareRemoteSDP':
        promise = setScreenShareRemoteSDP(data?.arguments[0].sdp);
        break;
      case 'setFullAudioRemoteSDP':
        promise = setFullAudioRemoteSDP(data?.arguments[0].sdp);
        break;
      case 'addRemoteIceCandidate':
        promise = addScreenShareRemoteIceCandidate(
          JSON.stringify(data?.arguments[0])
        );
        break;
      default:
        throw `Unknown method ${data?.method}`;
    }
    observePromiseResult(webViewRef, data.sequence, promise);
  } else {
    console.log(`Ignoring unknown message: $stringData`);
  }
}

export default { handleWebviewMessage };
