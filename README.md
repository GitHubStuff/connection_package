# connection_package

Notifies Bloc's when changes in Network connection changes. Also can report type of connection (WiFi, Celluar, or None)

## Useage

See example program.
The key class is <i>ConnectionBloc</i> that is provided to a 'NetworkStatus'-type class (two are provided <i>LiveNetwork</i> and <i>TestNetwork</i>)

The NetworkStatus the BLoC of ConnectionBloc and any time state changes[the event] (Network status performs async listening on network connectivity from the system), it will add a ConnectionChangedEvent to the ConnectionBloc, listerns of the connection block can listen/respond to those changes.

### Example

<pre>

enum NetworkConnectionType {
  Cellular,
  Internet,
  None,
  WiFi,
}

_connectionBloc = ConnectionBloc();
_liveNetwork = LiveNetwork(connectionBloc: _connectionBloc)..listen();

// Current status
_liveNetwork.connectionType().then((NetworkConnectionType value) {
      if (value.toString() != buttonText) {
        setState(() {
          buttonText = value.toString();
        });
      }
    });

// Listening
return BlocBuilder(
      bloc: _connectionBloc,
      builder: (context, state) {
        if (state is ConnectedWifiState) {
          return Center(child: Text('WIFI'));
        }
        if (state is ConnectedCelluarState) {
          return Center(child: Text('Celluar'));
        }
        return Center(child: Text('None'));
);

</pre>
