import { initializeScreenShare } from '../native-components/BBBN_ScreenShareService';

export function handleMethodCall(method: string, args: Array<any>) {
  console.log(`Handling call to method ${method}`, args);
  switch (method) {
    case 'initializeScreenShare':
      return initializeScreenShare();
  }
  throw `Unexpected method ${method}`;
}
