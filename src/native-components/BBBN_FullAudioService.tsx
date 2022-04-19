import { NativeModules } from 'react-native';

const FullAudioService = NativeModules.BBBN_FullAudioService;

// export function initializeFullAudio() {
//   FullAudioService.initializeFullAudio();
// }

export function createFullAudioOffer() {
  FullAudioService.createFullAudioOffer();
}

export function setFullAudioRemoteSDP(remoteSDP: string) {
  FullAudioService.setFullAudioRemoteSDP(remoteSDP);
}

// export function addFullAudioRemoteIceCandidate(remoteCandidateJson: string) {
//   FullAudioService.addFullAudioRemoteIceCandidate(remoteCandidateJson);
// }
