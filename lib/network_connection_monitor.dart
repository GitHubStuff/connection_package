import 'dart:async';

import 'package:connection_package/connection_package.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:tracers/tracers.dart' as Log;

/// Defines a class for a StreamController, that will have take care of
/// implementation details like access to the stream, and sink.
/// The 'void dispose()' abstract will "remind" implementations to
/// to call 'close()' to close the stream in the Widget class's 'void dispose()'
///
abstract class BroadcastStream<T> {
  final StreamController<T> _streamController = StreamController<T>.broadcast();
  Stream<T> get stream => _streamController.stream;
  Sink<T> get sink => _streamController.sink;

  void dispose();

  void close() => _streamController.close();
}

abstract class NetworkConnectionMonitorStream extends BroadcastStream<NetworkConnectionType> {
  NetworkConnectionMonitorStream() {
    //iOS doesn't get an initial network status, so this wil "force poll" to get connection state
    connectionType().then((networkConnectionType) {
      onChange(networkConnectionType);
    });
  }

  @override
  void dispose() {
    super.close();
  }

  Future<NetworkConnectionType> connectionType() async {
    final status = await (Connectivity().checkConnectivity());
    Log.p('{network_status.dart} connectionType {status: $status}');
    return _convertConnectivityToNetworkConnectionType(status);
  }

  Future<bool> dataConnection() async {
    final connection = await DataConnectionChecker().hasConnection;
    Log.p('{network_status.dart} dataConnection {connection: $connection}');
    return connection;
  }

  NetworkConnectionType _convertConnectivityToNetworkConnectionType(ConnectivityResult status) {
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

  void onChange(NetworkConnectionType result) async {
    await onConnectioned();
    sink.add(result);
  }

  Future<void> onConnectioned() async {
    bool connected = await dataConnection();
    sink.add(connected ? NetworkConnectionType.Internet : NetworkConnectionType.None);
  }
}

//class NetworkConnectionMonitor extends NetworkConnectionMonitorStream {}
