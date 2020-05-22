import 'dart:async';

import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

abstract class NetworkStatus {
  static ConnectivityResult currentState = ConnectivityResult.none;

  final ConnectionBloc _connectionBloc;
  StreamSubscription<ConnectivityResult> _subscription;

  NetworkStatus(ConnectionBloc connectionBloc) : _connectionBloc = connectionBloc {
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      onChange(result);
    });
  }

  void close() {
    _subscription?.cancel();
  }

  void onChange(ConnectivityResult result) {
    NetworkStatus.currentState = result;
    _connectionBloc.add(ConnectionChangedEvent(result));
  }
}

class LiveNetwork extends NetworkStatus {
  LiveNetwork({@required ConnectionBloc connectionBloc}) : super(connectionBloc);
}
