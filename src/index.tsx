/* eslint-disable react-native/no-inline-styles */
import { Platform, Text, View, ViewStyle } from 'react-native';
import React from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';
import { WebView } from 'react-native-webview';

type BigbluebuttonMobileSdkProps = {
  url: string;
  broadcastAppBundleId: string;
  style: ViewStyle;
};

export const BigbluebuttonMobile = ({
  url,
  broadcastAppBundleId,
  style,
}: BigbluebuttonMobileSdkProps) => {
  /* Broadcast picker is the button that allow calling the IOS broadcast feature */
  const broadcastPicker = Platform.select({
    ios: (
      <BBBN_SystemBroadcastPicker broadcastAppBundleId={broadcastAppBundleId} />
    ),
    android: null,
  });

  return (
    <>
      <>
        <View style={{ zIndex: 1 }}>{broadcastPicker}</View>
        <WebView source={{ uri: url }} style={{ ...style }} />
      </>
    </>
  );
};
