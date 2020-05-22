import 'dart:async';

import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

abstract class NetworkStatus {
  final ConnectionBloc _connectionBloc;
  StreamSubscription<ConnectivityResult> _subscription;

  NetworkStatus(ConnectionBloc connectionBloc) : _connectionBloc = connectionBloc;

  Future<ConnectivityResult> currentStatus() async => await (Connectivity().checkConnectivity());

  void close() {
    _subscription?.cancel();
    _subscription = null;
  }

  void listen() {
    if (_subscription != null) return;
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      onChange(result);
    });
  }

  void onChange(ConnectivityResult result) {
    _connectionBloc.add(ConnectionChangedEvent(result));
  }
}

class LiveNetwork extends NetworkStatus {
  LiveNetwork({@required ConnectionBloc connectionBloc}) : super(connectionBloc);
}

class TestNetwork extends NetworkStatus {
  final ConnectivityResult _connectivityResult;
  TestNetwork(ConnectionBloc connectionBloc, {@required ConnectivityResult connectivityResult})
      : _connectivityResult = connectivityResult,
        super(connectionBloc);

  @override
  void onChange(ConnectivityResult connectivity, [Duration delay = const Duration(milliseconds: 500)]) {
    Duration wait = delay ?? Duration(microseconds: 100);
    Future.delayed(wait, () {
      super.onChange(connectivity);
    });
  }

  @override
  Future<ConnectivityResult> currentStatus() async => Future.delayed(Duration(milliseconds: 600), () {
        return _connectivityResult;
      });

  @override
  void listen() {}
}
