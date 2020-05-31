import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
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

  Stream<ConnectionState> mapNetworkEventToState(ConnectivityResult connectivityState) async* {
    if (connectivityState == null) {
      yield ConnectionUnknownState();
    } else {
      switch (connectivityState) {
        case ConnectivityResult.mobile:
          yield ConnectedCelluarState();
          break;
        case ConnectivityResult.none:
          yield ConnectionLostState();
          break;
        case ConnectivityResult.wifi:
          yield ConnectedWifiState();
          break;
      }
    }
  }
}
