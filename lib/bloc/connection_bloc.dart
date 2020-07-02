import 'dart:async';
import 'package:bloc/bloc.dart';
import '../connection_package.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc(ConnectionState initialState) : super(initialState);

  @override
  Stream<ConnectionState> mapEventToState(dynamic event) async* {
    if (event is ConnectionChangedEvent) {
      yield* mapNetworkEventToState(event.type);
    } else if (event is DataAccessEvent) {
      yield DataAccessState(event.connected);
    }
  }

  Stream<ConnectionState> mapNetworkEventToState(NetworkConnectionType connectivityState) async* {
    switch (connectivityState) {
      case NetworkConnectionType.Cellular:
        yield ConnectedCelluarState();
        break;
      case NetworkConnectionType.None:
        yield NoConnectionState();
        break;
      case NetworkConnectionType.WiFi:
        yield ConnectedWifiState();
        break;
    }
  }
}
