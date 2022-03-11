import { NativeModules } from 'react-native';

const ScreenShareService = NativeModules.BBBN_ScreenShareService;

export function initializeScreenShare() {
  ScreenShareService.initializeScreenShare();
}
