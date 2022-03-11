import { initializeScreenShare as nativeInitializeScreenShare } from '../native-components/BBBN_ScreenShareService';
import nativeEmitter from '../native-messaging/emitter';

// Reference to the resolver of last call
let resolve = (a: String) => {
  console.log(
    `default resolve function called, this should never happen: ${a}`
  );
};

// Log a message when broadcast is requested
nativeEmitter.addListener('onBroadcastRequested', () => {
  console.log(`Broadcast requested`);
});

// Resolve promise when broadcast is started (this event means that user confirmed the screenshare)
nativeEmitter.addListener('onBroadcastStarted', () => {
  resolve('null');
});

// Entry point of this method
function initializeScreenShare() {
  return new Promise((res, rej) => {
    // store the resolver for later call (when event is received)
    resolve = res;

    try {
      // call native swift method that triggers the broadcast popup
      nativeInitializeScreenShare();
    } catch (e) {
      rej(`Call to nativeInitializeScreenShare failed`);
    }
  });
}

export default initializeScreenShare;
