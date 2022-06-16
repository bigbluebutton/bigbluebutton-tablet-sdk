import { stopScreenShareBroadcastExtension as nativeStopScreenShare } from '../native-components/BBBN_ScreenShareService';
import nativeEmitter from '../native-messaging/emitter';

// Reference to the resolver of last call
let resolve = (a: String | null) => {
  console.log(
    `default resolve function called, this should never happen: ${a}`
  );
};

// Resolve promise when broadcast is started (this event means that user confirmed the screenshare)
nativeEmitter.addListener('onBroadcastFinished', () => {
  resolve(null);
});

// Entry point of this method
function stopScreenShare(instanceId: Number) {
  return new Promise((res, rej) => {
    // store the resolver for later call (when event is received)
    resolve = res;

    try {
      // call native swift method that triggers the broadcast popup
      console.log(`[${instanceId}] - >stopScreenShare`);
      nativeStopScreenShare();
    } catch (e) {
      rej(`Call to stopScreenShare failed zzy`);
    }
  });
}

export default stopScreenShare;
