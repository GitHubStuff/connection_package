import 'dart:async';

import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:tracers/tracers.dart' as Log;

import '../bloc/connection_bloc.dart';
import '../connection_package.dart';

abstract class NetworkStatus {
  final ConnectionBloc _connectionBloc;
  StreamSubscription<ConnectivityResult> _subscription;

  NetworkStatus(ConnectionBloc connectionBloc) : _connectionBloc = connectionBloc {
    //iOS doesn't get an initial network status, so this wil "force poll" to get connection state
    connectionType().then((networkConnectionType) {
      onChange(networkConnectionType);
    });
  }

  Future<NetworkConnectionType> connectionType() async {
    final status = await (Connectivity().checkConnectivity());
    Log.t('{network_status.dart} connectionType {status: $status}');
    return _mapToAppNetworkStatus(status);
  }

  Future<bool> dataConnection({bool mock}) async {
    final connection = mock ?? await DataConnectionChecker().hasConnection;
    Log.t('{network_status.dart} dataConnection {connection: $connection}');
    return connection;
  }

  NetworkConnectionType _mapToAppNetworkStatus(ConnectivityResult status) {
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
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      final result = _mapToAppNetworkStatus(connectivityResult);
      onChange(result);
    });
  }

  void onChange(NetworkConnectionType result) {
    onConnectioned();
    _connectionBloc.add(ConnectionChangedEvent(result));
  }

  Future<void> onConnectioned() async {
    bool connected = await dataConnection();
    _connectionBloc.add(DataAccessEvent(connected));
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
  Future<NetworkConnectionType> connectionType() async => Future.delayed(Duration(milliseconds: 600), () {
        return _connectivityResult;
      });

  @override
  void listen() {}
}
