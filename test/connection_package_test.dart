import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:connection_package/network/network_status.dart';

class MockNetwork extends Mock implements LiveNetwork {
  MockNetwork(ConnectionBloc bloc);
}

void main() {
  MockNetwork mockNetwork;
  ConnectionBloc connectionBloc;

  setUp(() {
    mockNetwork = MockNetwork(null);
    connectionBloc = ConnectionBloc();
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
    expectLater(
      connectionBloc,
      emitsInOrder(expectedResponse),
    );

    connectionBloc.add(ConnectionChangedEvent(ConnectivityResult.wifi));
  });

  test('Network reported change to "wifi"', () {
    final expectedResponse = [
      ConnectionInitialState(),
      ConnectedWifiState(),
    ];
    expectLater(
      connectionBloc,
      emitsInOrder(expectedResponse),
    );
    mockNetwork.onChange(ConnectivityResult.wifi);
  });
}
