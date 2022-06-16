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

export function addScreenShareRemoteIceCandidate(remoteCandidateJson: string) {
  ScreenShareService.addScreenShareRemoteIceCandidate(remoteCandidateJson);
}

export function stopScreenShareBroadcastExtension() {
  ScreenShareService.stopScreenShareBroadcastExtension();
}
