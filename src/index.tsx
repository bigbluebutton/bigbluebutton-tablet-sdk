import { Platform, ViewStyle } from 'react-native';
import React from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';
import { WebView } from 'react-native-webview';

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
  return (
    <>
      {renderPlatformSpecificComponents(broadcastAppBundleId)}
      {<WebView source={{ uri: url }} style={{ ...style }} />}
    </>
  );
};
