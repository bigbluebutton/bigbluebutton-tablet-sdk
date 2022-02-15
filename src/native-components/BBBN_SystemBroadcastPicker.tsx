import { HostComponent, requireNativeComponent } from 'react-native';
interface Props {
  broadcastAppBundleId: string;
}

const BBBN_SystemBroadcastPicker: HostComponent<Props> = requireNativeComponent(
  'BBBN_SystemBroadcastPicker'
);

export default BBBN_SystemBroadcastPicker;
