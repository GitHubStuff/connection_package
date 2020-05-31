//part of 'connection_bloc.dart';

import 'package:equatable/equatable.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();
  List<Object> get props => [];
}

class ConnectedCelluarState extends ConnectionState {
  const ConnectedCelluarState();
}

class ConnectionInitialState extends ConnectionState {
  const ConnectionInitialState();
}

class ConnectedWifiState extends ConnectionState {
  const ConnectedWifiState();
}

class NoConnectionState extends ConnectionState {
  const NoConnectionState();
}
