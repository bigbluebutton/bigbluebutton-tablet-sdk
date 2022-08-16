import type { MutableRefObject } from 'react';
import type { WebView, WebViewMessageEvent } from 'react-native-webview';
import initializeScreenShare from '../methods/initializeScreenShare';
import createScreenShareOffer from '../methods/createScreenShareOffer';
import setScreenShareRemoteSDP from '../methods/setScreenShareRemoteSDP';
import setFullAudioRemoteSDP from '../methods/setFullAudioRemoteSDP';
import addScreenShareRemoteIceCandidate from '../methods/addScreenShareRemoteIceCandidate';
import createFullAudioOffer from '../methods/createFullAudioOffer';
import stopScreenShare from '../methods/stopScreenShare';

function observePromiseResult(
  instanceId: Number,
  webViewRef: MutableRefObject<WebView>,
  sequence: number,
  prom: Promise<any>
) {
  prom
    .then((result: any) => {
      console.log(`[${instanceId}] - Promise ${sequence} resolved!`, result);
      webViewRef.current.injectJavaScript(
        `window.nativeMethodCallResult(${sequence}, true ${
          result ? ',' + JSON.stringify(result) : ''
        });`
      );
    })
    .catch((exception: any) => {
      console.error(`[${instanceId}] - Promise ${sequence} failed!`, exception);
      webViewRef.current.injectJavaScript(
        `window.nativeMethodCallResult(${sequence}, false ${
          exception ? ',' + JSON.stringify(exception) : ''
        });`
      );
    });
}

export function handleWebviewMessage(
  instanceId: Number,
  webViewRef: MutableRefObject<any>,
  event: WebViewMessageEvent
) {
  const stringData = event?.nativeEvent?.data;

  console.log('handleWebviewMessage - ', instanceId);

  const data = JSON.parse(stringData);
  if (data?.method && data?.sequence) {
    let promise;
    switch (data?.method) {
      case 'initializeScreenShare':
        promise = initializeScreenShare(instanceId);
        break;
      case 'createFullAudioOffer':
        promise = createFullAudioOffer(instanceId);
        break;
      case 'createScreenShareOffer':
        promise = createScreenShareOffer(instanceId);
        break;
      case 'setScreenShareRemoteSDP':
        promise = setScreenShareRemoteSDP(instanceId, data?.arguments[0].sdp);
        break;
      case 'setFullAudioRemoteSDP':
        promise = setFullAudioRemoteSDP(instanceId, data?.arguments[0].sdp);
        break;
      case 'addRemoteIceCandidate':
        promise = addScreenShareRemoteIceCandidate(
          instanceId,
          JSON.stringify(data?.arguments[0])
        );
        break;
      case 'stopScreenShare':
        promise = stopScreenShare(instanceId);
        break;
      default:
        throw `[${instanceId}] - Unknown method ${data?.method}`;
    }
    observePromiseResult(instanceId, webViewRef, data.sequence, promise);
  } else {
    console.log(`[${instanceId}] - Ignoring unknown message: $stringData`);
  }
}

export default { handleWebviewMessage };
