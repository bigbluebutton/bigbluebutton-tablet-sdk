import { setFullAudioRemoteSDP as nativeSetFullAudioRemoteSDP } from '../native-components/BBBN_FullAudioService';
import nativeEmitter from '../native-messaging/emitter';

// Reference to the resolver of last call
let resolve = (value: unknown) => {
  console.log(
    `default resolve function called, this should never happen: ${value}`
  );
};

// Resolve promise when SDP offer is available
nativeEmitter.addListener('onSetFullAudioRemoteSDPCompleted', () => {
  resolve(undefined);
});

// Entry point of this method
function setFullAudioRemoteSDP(instanceId: Number, remoteSdp: string) {
  return new Promise((res, rej) => {
    // store the resolver for later call (when event is received)
    resolve = res;

    try {
      console.log(
        `[${instanceId}] - >nativeSetFullAudioRemoteSDP ${remoteSdp}`
      );
      // call native swift method that triggers the broadcast popup
      nativeSetFullAudioRemoteSDP(remoteSdp);
    } catch (e) {
      rej(`Call to nativeSetFullAudioRemoteSDP failed`);
    }
  });
}

export default setFullAudioRemoteSDP;
