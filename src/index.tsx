import { Platform, ViewStyle } from 'react-native';
import React, { useRef } from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';
import { WebView } from 'react-native-webview';
import { handleWebviewMessage } from './webview/message-handler';

type BigbluebuttonMobileSdkProps = {
  url: string;
  style: ViewStyle;
  onError: Function;
};

const renderPlatformSpecificComponents = () =>
  Platform.select({
    ios: <BBBN_SystemBroadcastPicker />,
    android: null,
  });

export const BigbluebuttonMobile = ({
  url,
  style,
  onError,
}: BigbluebuttonMobileSdkProps) => {
  const webViewRef = useRef(null);

  return (
    <>
      {renderPlatformSpecificComponents()}
      {
        <WebView
          ref={webViewRef}
          source={{ uri: url }}
          style={{ ...style }}
          onMessage={(msg) => handleWebviewMessage(webViewRef, msg)}
          applicationNameForUserAgent="BBBMobile"
          onError={(e) => onError(e.nativeEvent.code)}
        />
      }
    </>
  );
};
