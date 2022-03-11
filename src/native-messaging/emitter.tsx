import * as reactNative from 'react-native';
// ...
const emitter: reactNative.EventEmitter =
  reactNative.Platform.OS === 'ios'
    ? new reactNative.NativeEventEmitter(
        reactNative.NativeModules.ReactNativeEventEmitter
      )
    : reactNative.DeviceEventEmitter;

export default emitter;
