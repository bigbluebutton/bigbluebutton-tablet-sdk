import * as React from 'react';

import { Alert, StyleSheet, Text, View } from 'react-native';
import { BigBlueButtonTablet } from 'bigbluebutton-tablet-sdk';
import type { INativeEvent } from './types';

export default function App() {
  const [loadComponent, setLoadComponent] = React.useState(true);

  const handleOnError = React.useCallback((content: any) => {
    const nativeEvent = content.nativeEvent as INativeEvent;
    console.log(
      `Error loading URL ${nativeEvent.url}: ${nativeEvent.description}`
    );
    setLoadComponent(false);
    Alert.alert('Error loading URL', undefined, [
      {
        text: 'Cancel',
        onPress: () => console.log('Cancel Pressed'),
        style: 'cancel',
      },
      {
        text: 'Retry',
        onPress: () => {
          console.log('Retry Pressed');
          setLoadComponent(true);
        },
      },
    ]);
  }, []);

  return (
    <View style={styles.container}>
      {loadComponent ? (
        <BigBlueButtonTablet
          url="https://demo-ios.bigbluebutton.org"
          style={styles.bbb}
          onError={(content: any) => handleOnError(content)}
          onSuccess={() => console.log('URL Valid')}
        />
      ) : (
        <Text style={styles.text}>Invalid URL</Text>
      )}
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
  text: {
    marginTop: 48,
    flex: 1,
    justifyContent: 'center',
    alignContent: 'center',
  },
});
