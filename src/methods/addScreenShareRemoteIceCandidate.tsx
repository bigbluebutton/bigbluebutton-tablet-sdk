import { addScreenShareRemoteIceCandidate as nativeAddScreenShareRemoteIceCandidate } from '../native-components/BBBN_ScreenShareService';
import nativeEmitter from '../native-messaging/emitter';

// Reference to the resolver of last call
let resolve = (value: unknown) => {
  console.log(
    `default resolve function called, this should never happen: ${value}`
  );
};

// Resolve promise when SDP offer is available
nativeEmitter.addListener('onAddScreenShareRemoteIceCandidateCompleted', () => {
  resolve(undefined);
});

// Entry point of this method
function addScreenShareRemoteIceCandidate(
  instanceId: Number,
  remoteCandidateJson: string
) {
  return new Promise((res, rej) => {
    // store the resolver for later call (when event is received)
    resolve = res;

    try {
      console.log(
        `[${instanceId}] - >nativeAddScreenShareRemoteIceCandidate ${remoteCandidateJson}`
      );
      // call native swift method that triggers the broadcast popup
      nativeAddScreenShareRemoteIceCandidate(remoteCandidateJson);
    } catch (e) {
      rej(`Call to nativeAddScreenShareRemoteIceCandidate failed`);
    }
  });
}

export default addScreenShareRemoteIceCandidate;
