import { HostComponent, requireNativeComponent } from 'react-native';
interface Props {}

const BBBN_SystemBroadcastPicker: HostComponent<Props> = requireNativeComponent(
  'BBBN_SystemBroadcastPicker'
);

export default BBBN_SystemBroadcastPicker;
