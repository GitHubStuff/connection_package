//part of 'connection_bloc.dart';

import 'package:equatable/equatable.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();
  List<Object> get props => [];
}

class ConnectedCelluarState extends ConnectionState {
  const ConnectedCelluarState();
}

class ConnectedWifiState extends ConnectionState {
  const ConnectedWifiState();
}

class ConnectionInitialState extends ConnectionState {
  const ConnectionInitialState();
}

class ConnectionLostState extends ConnectionState {
  const ConnectionLostState();
}

class ConnectionUnknownState extends ConnectionState {
  const ConnectionUnknownState();
}
