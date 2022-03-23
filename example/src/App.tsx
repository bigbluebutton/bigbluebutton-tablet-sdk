import * as React from 'react';

import { Alert, StyleSheet, View } from 'react-native';
import { BigbluebuttonMobile } from 'bigbluebutton-mobile-sdk';

export default function App() {
  function onError(e: string) {
    Alert.alert('Page not exists', e);
  }
  return (
    <View style={styles.container}>
      <BigbluebuttonMobile
        url="https://mobile.bbb.imdt.dev"
        style={styles.bbb}
        onError={(e: any) => onError(e)}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
  },
  bbb: {
    marginTop: 48,
    flex: 1,
  },
});
