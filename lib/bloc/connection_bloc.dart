import 'dart:async';
import 'package:bloc/bloc.dart';
import '../connection_package.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  @override
  ConnectionState get initialState => ConnectionInitialState();

  @override
  Stream<ConnectionState> mapEventToState(dynamic event) async* {
    if (event is ConnectionChangedEvent) {
      yield* mapNetworkEventToState(event.type);
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
