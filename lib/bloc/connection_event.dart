import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();
  List<Object> get props => [];
}

class ConnectionChangedEvent extends ConnectionEvent {
  final ConnectivityResult type;
  const ConnectionChangedEvent(this.type);
  @override
  List<Object> get props => [type];
}
