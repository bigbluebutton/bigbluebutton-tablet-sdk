import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { BigbluebuttonMobile } from 'bigbluebutton-mobile-sdk';

export default function App() {
  return (
    <View style={styles.container}>
      <BigbluebuttonMobile
        broadcastAppBundleId="org.bigbluebutton.mobile.BigBlueButton.BroadcastUpload"
        url="https://demo.bigbluebutton.org"
        style={styles.box}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
  },
  box: {
    marginTop: 48,
    flex: 1,
  },
});
