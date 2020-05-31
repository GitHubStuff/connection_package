import 'dart:async';

import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import '../bloc/connection_bloc.dart';
import '../connection_package.dart';

abstract class NetworkStatus {
  final ConnectionBloc _connectionBloc;
  StreamSubscription<ConnectivityResult> _subscription;

  NetworkStatus(ConnectionBloc connectionBloc) : _connectionBloc = connectionBloc {
    currentStatus().then((networkConnectionType) {
      onChange(networkConnectionType);
    });
  }

  Future<NetworkConnectionType> currentStatus() async {
    final status = await (Connectivity().checkConnectivity());
    switch (status) {
      case ConnectivityResult.mobile:
        return NetworkConnectionType.Cellular;
      case ConnectivityResult.none:
        return NetworkConnectionType.None;
      case ConnectivityResult.wifi:
        return NetworkConnectionType.WiFi;
    }
    throw Exception('Unknown status ${status.toString()}');
  }

  void close() {
    _subscription?.cancel();
    _subscription = null;
  }

  void listen() {
    if (_subscription != null) return;
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.mobile:
          onChange(NetworkConnectionType.Cellular);
          break;
        case ConnectivityResult.none:
          onChange(NetworkConnectionType.None);
          break;
        case ConnectivityResult.wifi:
          onChange(NetworkConnectionType.WiFi);
          break;
      }
    });
  }

  void onChange(NetworkConnectionType result) {
    _connectionBloc.add(ConnectionChangedEvent(result));
  }
}

// MARK:
class LiveNetwork extends NetworkStatus {
  LiveNetwork({@required ConnectionBloc connectionBloc}) : super(connectionBloc);
}

// MARK:
class TestNetwork extends NetworkStatus {
  NetworkConnectionType _connectivityResult;
  TestNetwork(ConnectionBloc connectionBloc, {@required NetworkConnectionType connectivityResult})
      : _connectivityResult = connectivityResult,
        super(connectionBloc);

  @override
  void onChange(NetworkConnectionType connectivity, [Duration delay = const Duration(milliseconds: 500)]) {
    Duration wait = delay ?? Duration(microseconds: 100);
    Future.delayed(wait, () {
      _connectivityResult = connectivity;
      super.onChange(connectivity);
    });
  }

  @override
  Future<NetworkConnectionType> currentStatus() async => Future.delayed(Duration(milliseconds: 600), () {
        return _connectivityResult;
      });

  @override
  void listen() {}
}
