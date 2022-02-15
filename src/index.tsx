import { Platform, ViewStyle, Text } from 'react-native';
import React from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';

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
      {broadcastPicker}
      <Text style={style}>BigBlueButton mobile {url}</Text>
    </>
  );
};
