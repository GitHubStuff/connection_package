// Copyright 2020 LTMM. All rights reserved.
// Uses of this source code is governed by 'The Unlicense' that can be
// found in the LICENSE file.

library connection_package;

export 'network_connection_monitor.dart';

enum NetworkConnectionType {
  Cellular,
  Internet,
  None,
  WiFi,
}
