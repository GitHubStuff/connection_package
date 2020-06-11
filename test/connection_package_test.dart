import 'package:connection_package/connection_package.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNetwork extends Mock implements NetworkConnectionMonitorStream {}

void main() {
  MockNetwork mockNetwork;

  setUp(() {
    mockNetwork = MockNetwork()..listen();
  });

  tearDown(() {
    mockNetwork.close();
  });

  testWidgets('close does not emit new states', (WidgetTester tester) async {
    await tester.pumpWidget(
      StreamBuilder<NetworkConnectionType>(
          stream: mockNetwork.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: Text('WAITING'));
            final state = snapshot.data;
            if (state == NetworkConnectionType.WiFi) {
              return Center(child: Text('WIFI'));
            }
            if (state == NetworkConnectionType.Cellular) {
              return Center(child: Text('Celluar'));
            }
            return null;
          }),
    );

    await tester.pump(Duration.zero);
    Finder widget = find.byType(Center);
    expect(widget, findsOneWidget);
  });
}
