import { NativeModules } from 'react-native';

const ScreenShareService = NativeModules.BBBN_ScreenShareService;

export function initializeScreenShare() {
  ScreenShareService.initializeScreenShare();
}

export function createScreenShareOffer(stunTurnJson:String) {
  ScreenShareService.createScreenShareOffer(stunTurnJson);
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
