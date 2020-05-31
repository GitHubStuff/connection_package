import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connection_package/bloc/connection_state.dart';
import 'package:connection_package/connection_package.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:connection_package/network/network_status.dart';

class MockNetwork extends Mock implements LiveNetwork {
  MockNetwork(ConnectionBloc bloc) : super();
}

void main() {
  MockNetwork mockNetwork;
  ConnectionBloc connectionBloc;

  setUp(() {
    connectionBloc = ConnectionBloc();
    mockNetwork = MockNetwork(connectionBloc);
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

    connectionBloc.add(ConnectionChangedEvent(NetworkConnectionType.WiFi));
  });

  test('Network reported change to "wifi"', () async {
    final expectedResponse = [
      ConnectionInitialState(),
      ConnectedWifiState(),
    ];
    expectLater(
      connectionBloc,
      emitsInOrder(expectedResponse),
    );
    final network = TestNetwork(connectionBloc, connectivityResult: NetworkConnectionType.WiFi);
    network.onChange(NetworkConnectionType.WiFi);
  });
}
