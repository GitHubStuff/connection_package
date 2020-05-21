import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:connection_package/network/network_status.dart';

class MockNetwork extends Mock implements TestNetwork {}

void main() {
  MockNetwork mockNetwork;
  ConnectionBloc connectionBloc;

  setUp(() {
    mockNetwork = MockNetwork();
    connectionBloc = ConnectionBloc(networkStatus: mockNetwork);
  });

  tearDown(() {
    mockNetwork.close();
  });

  test('initial state is correct', () {
    expect(connectionBloc.initialState, ConnectionInitialState());
  });

  test('close does not emit new states', () {
    expectLater(
      connectionBloc,
      emitsInOrder([ConnectionInitialState(), emitsDone]),
    );
    connectionBloc.close();
  });

  test('Changed state to "wifi"', () {
    final expectedResponse = [
      ConnectionInitialState(),
      ConnectedWifiState(),
    ];
    debugPrint('Trace');
    expectLater(
      connectionBloc,
      emitsInOrder(expectedResponse),
    ).then((item) {
      debugPrint('Finished');
    });

    connectionBloc.add(ConnectionChangedEvent(ConnectivityResult.wifi));
    debugPrint('done....');
  });
}
