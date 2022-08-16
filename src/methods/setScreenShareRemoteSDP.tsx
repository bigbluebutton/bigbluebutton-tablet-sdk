import { setScreenShareRemoteSDP as nativeSetScreenShareRemoteSDP } from '../native-components/BBBN_ScreenShareService';
import nativeEmitter from '../native-messaging/emitter';

// Reference to the resolver of last call
let resolve = (value: unknown) => {
  console.log(
    `default resolve function called, this should never happen: ${value}`
  );
};

// Resolve promise when SDP offer is available
nativeEmitter.addListener('onSetScreenShareRemoteSDPCompleted', () => {
  resolve(undefined);
});

// Entry point of this method
function setScreenShareRemoteSDP(instanceId: Number, remoteSdp: string) {
  return new Promise((res, rej) => {
    // store the resolver for later call (when event is received)
    resolve = res;

    try {
      console.log(
        `[${instanceId}] - >nativeSetScreenShareRemoteSDP ${remoteSdp}`
      );
      // call native swift method that triggers the broadcast popup
      nativeSetScreenShareRemoteSDP(remoteSdp);
    } catch (e) {
      rej(`Call to nativeSetScreenShareRemoteSDP failed`);
    }
  });
}

export default setScreenShareRemoteSDP;
