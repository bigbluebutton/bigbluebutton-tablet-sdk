import { Platform, ViewStyle, Text } from 'react-native';
import React from 'react';
import BBBN_SystemBroadcastPicker from './native-components/BBBN_SystemBroadcastPicker';

type BigbluebuttonMobileSdkProps = {
  url: string;
  style: ViewStyle;
};

export const BigbluebuttonMobile = ({
  url,
  style,
}: BigbluebuttonMobileSdkProps) => {
  return (
    <>
      {Platform.select({
        ios: <BBBN_SystemBroadcastPicker />,
        android: null,
      })}
      <Text style={style}>BigBlueButton mobile {url}</Text>
    </>
  );
};
