// Copyright 2020 LTMM. All rights reserved.
// Uses of this source code is governed by 'The Unlicense' that can be
// found in the LICENSE file.

import 'package:equatable/equatable.dart';

import '../connection_package.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();
  List<Object> get props => [];
}

class ConnectionChangedEvent extends ConnectionEvent {
  final NetworkConnectionType type;
  const ConnectionChangedEvent(this.type);
  @override
  List<Object> get props => [type];
}

class DataAccessEvent extends ConnectionEvent {
  final bool connected;
  const DataAccessEvent(this.connected);
  @override
  List<Object> get props => [connected];
}
