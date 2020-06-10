library connection_package;

export 'bloc/connection_state.dart';
export 'bloc/connection_event.dart';
export 'bloc/connection_bloc.dart';
export 'network/network_status.dart';
export 'network_connection_monitor.dart';

enum NetworkConnectionType {
  Cellular,
  Internet,
  None,
  WiFi,
}
