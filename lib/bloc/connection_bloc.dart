import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connection_package/network/network_status.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final NetworkStatus networkStatus;

  ConnectionBloc({@required this.networkStatus}) {
    _subscription = networkStatus?.listen;
  }

  var _subscription;

  @override
  ConnectionState get initialState => ConnectionInitialState();

  @override
  Stream<ConnectionState> mapEventToState(ConnectionEvent event) async* {
    if (event is ConnectionStopEvent) {
      networkStatus.cancel(_subscription);
    } else if (event is ConnectionChangedEvent) {
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
