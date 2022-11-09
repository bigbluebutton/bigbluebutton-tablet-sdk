import { createFullAudioOffer as nativeCreateFullAudioOffer } from '../native-components/BBBN_FullAudioService';
import nativeEmitter from '../native-messaging/emitter';

// Reference to the resolver of last call
let resolve = (a: String) => {
  console.log(
    `default resolve function called, this should never happen: ${a}`
  );
};

// Resolve promise when SDP offer is available
nativeEmitter.addListener('onFullAudioOfferCreated', (sdp) => {
  resolve(sdp);
});

// Entry point of this method
function createFullAudioOffer(instanceId: Number, stunTurnJson: String) {
  return new Promise((res, rej) => {
    // store the resolver for later call (when event is received)
    resolve = res;

    try {
      console.log(
        `[${instanceId}] - >nativeCreateFullAudioOffer (${stunTurnJson})`
      );
      // call native swift method that triggers the broadcast popup
      nativeCreateFullAudioOffer(stunTurnJson);
    } catch (e) {
      rej(`Call to nativeCreateFullAudioOffer failed`);
    }
  });
}

export default createFullAudioOffer;
