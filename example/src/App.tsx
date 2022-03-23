import * as React from 'react';

import { SafeAreaView, StyleSheet } from 'react-native';
import { BigbluebuttonMobile } from 'bigbluebutton-mobile-sdk';

export default function App() {
  function ErrorInPage(e: string){
    console.log('code of error', e)
  }
  return (
    
      <SafeAreaView style={{flex: 1}}>        
        <BigbluebuttonMobile
          url="https://mobile.bbb.imdt.dev"
          style={styles.bbb}        
          onError={(e:any)=>ErrorInPage(e)}
        />
      </SafeAreaView>
  
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
