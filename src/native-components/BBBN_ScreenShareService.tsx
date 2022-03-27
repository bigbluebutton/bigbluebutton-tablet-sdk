import { NativeModules } from 'react-native';

const ScreenShareService = NativeModules.BBBN_ScreenShareService;

export function initializeScreenShare() {
  ScreenShareService.initializeScreenShare();
}

export function createScreenShareOffer() {
  ScreenShareService.createScreenShareOffer();
}

export function setScreenShareRemoteSDP(remoteSDP: string) {
  ScreenShareService.setScreenShareRemoteSDP(remoteSDP);
}
