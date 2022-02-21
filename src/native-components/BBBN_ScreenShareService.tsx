import { NativeModules } from 'react-native';

const ScreenShareService = NativeModules.BBBN_ScreenShareService;

export function initializeScreenShare(): Promise<Boolean> {
  return ScreenShareService.initializeScreenShare();
}
