part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();
  List<Object> get props => [];
}

class ConnectionStopEvent extends ConnectionEvent {
  const ConnectionStopEvent();
}

class ConnectionChangedEvent extends ConnectionEvent {
  final ConnectivityResult type;
  const ConnectionChangedEvent(this.type);
  @override
  List<Object> get props => [type];
}
