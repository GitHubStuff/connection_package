import 'dart:async';

import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

abstract class NetworkStatus {
  static ConnectivityResult currentState = ConnectivityResult.none;

  final ConnectionBloc _connectionBloc;
  
  NetworkStatus(ConnectionBloc connectionBloc) : _connectionBloc = connectionBloc;

  void close() {
    _connectionBloc.close();
  }

  void cancel(StreamSubscription<ConnectivityResult> subscription) {
    subscription?.cancel();
  }

  void onChange(ConnectivityResult result) {
    NetworkStatus.currentState = result;
    _connectionBloc.mapNetworkEventToState(result);
  }

  StreamSubscription<ConnectivityResult> listen(
    void onData(ConnectivityResult event), {
    Function onError,
    void onDone(),
    bool cancelOnError,
  }) {
    return Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      onChange(result);
    });
  }
}

class LiveNetwork extends NetworkStatus {
  LiveNetwork({@required ConnectionBloc connectionBloc}) : super(connectionBloc);
}

class TestNetwork extends NetworkStatus {
  TestNetwork({@required ConnectionBloc connectionBloc}) : super(connectionBloc);

  @override
  StreamSubscription<ConnectivityResult> listen(
    void onData(ConnectivityResult event), {
    Function onError,
    void onDone(),
    bool cancelOnError,
  }) {
    return null;
  }
}
