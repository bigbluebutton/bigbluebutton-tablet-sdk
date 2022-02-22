import { Platform, ViewStyle } from 'react-native';
import React, { useRef } from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';
import { WebView } from 'react-native-webview';
import { handleWebviewMessage } from './webview/message-handler';

type BigbluebuttonMobileSdkProps = {
  url: string;
  broadcastAppBundleId: string;
  style: ViewStyle;
};

const renderPlatformSpecificComponents = (broadcastAppBundleId: string) =>
  Platform.select({
    ios: (
      <BBBN_SystemBroadcastPicker broadcastAppBundleId={broadcastAppBundleId} />
    ),
    android: null,
  });

export const BigbluebuttonMobile = ({
  url,
  broadcastAppBundleId,
  style,
}: BigbluebuttonMobileSdkProps) => {
  const webViewRef = useRef(null);

  return (
    <>
      {renderPlatformSpecificComponents(broadcastAppBundleId)}
      {
        <WebView
          ref={webViewRef}
          source={{ uri: url }}
          style={{ ...style }}
          onMessage={(msg) => handleWebviewMessage(webViewRef, msg)}
          applicationNameForUserAgent="BBBMobile"
        />
      }
    </>
  );
};
