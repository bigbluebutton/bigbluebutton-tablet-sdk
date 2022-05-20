import { EmitterSubscription, Platform, ViewStyle } from 'react-native';
import React, { useEffect, useRef } from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';
import { WebView } from 'react-native-webview';
import { handleWebviewMessage } from './webview/message-handler';
import * as onScreenShareLocalIceCandidate from './events/onScreenShareLocalIceCandidate';
import * as onScreenShareSignalingStateChange from './events/onScreenShareSignalingStateChange';
import * as onBroadcastFinished from './events/onBroadcastFinished';

type BigbluebuttonMobileSdkProps = {
  url: string;
  style: ViewStyle;
  onError?: any;
  onSuccess?: any;
};

const data = {
  instances: 0
}

const renderPlatformSpecificComponents = () =>
  Platform.select({
    ios: <BBBN_SystemBroadcastPicker />,
    android: null,
  });

export const BigBlueButtonMobile = ({
  url,
  style,
  onError,
  onSuccess,
}: BigbluebuttonMobileSdkProps) => {
  const webViewRef = useRef(null);
  const thisInstanceId = ++data.instances;

  // console.log("XXX - ", thisInstanceId);

  useEffect(() => {
    const logPrefix = `[${thisInstanceId}] - ${url.substring(8, 16)}`;
    
    console.log(`${logPrefix} - addingListeners`);
    const listeners:EmitterSubscription[] = [];
    listeners.push(onScreenShareLocalIceCandidate.setupListener(webViewRef));
    listeners.push(onScreenShareSignalingStateChange.setupListener(webViewRef));
    listeners.push(onBroadcastFinished.setupListener(webViewRef));

    return () => {
      console.log(`${logPrefix} - Removing listeners`);
      
      listeners.forEach( (listener, index) => {
        console.log(`${logPrefix} - Removing listener ${index}`);
        listener.remove();
       } );
    }
  }, [webViewRef]);

  return (
    <>
      {renderPlatformSpecificComponents()}
      {
        <WebView
          ref={webViewRef}
          source={{ uri: url }}
          style={{ ...style }}
          contentMode={'mobile'}
          onMessage={(msg) => handleWebviewMessage(thisInstanceId, webViewRef, msg)}
          applicationNameForUserAgent="BBBMobile"
          allowsInlineMediaPlayback={true}
          mediaCapturePermissionGrantType={'grant'}
          onLoadEnd={(content: any) => {
            /*in case of success, the property code is not defined*/
            if (typeof content.nativeEvent.code !== 'undefined') {
              if (onError) onError(content);
            } else {
              if (onSuccess) onSuccess(content);
            }
          }}
        />
      }
    </>
  );
};
