// Copyright 2020 LTMM. All rights reserved.
// Uses of this source code is governed by 'The Unlicense' that can be
// found in the LICENSE file.

import 'package:after_layout/after_layout.dart';
import 'package:connection_package/bloc/connection_bloc.dart';
import 'package:connection_package/bloc/connection_state.dart';
import 'package:connection_package/network/network_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hud_scaffold/hud_scaffold.dart';
import 'package:mode_theme/mode_theme.dart';
import 'package:tracers/tracers.dart' as Log;

void main() => runApp(ZerkyApp());

class ZerkyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModeTheme(
      themeDataFunction: (brightness) => (brightness == Brightness.light) ? ModeTheme.light : ModeTheme.dark,
      defaultBrightness: Brightness.light,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          home: Zerky(),
          initialRoute: '/',
          routes: {
            Zerky.route: (context) => ZerkyApp(),
          },
          theme: theme,
          title: 'ZerkyApp Demo',
        );
      },
    );
  }
}

///-------------------------------------------------------------------------------------
class Zerky extends StatefulWidget {
  const Zerky({Key key}) : super(key: key);
  static const route = '/zerky';

  @override
  _Zerky createState() => _Zerky();
}

///-------------------------------------------------------------------------------------
class _Zerky extends State<Zerky> with WidgetsBindingObserver, AfterLayoutMixin<Zerky> {
  bool hideSpinner = true;
  // ignore: close_sinks
  ConnectionBloc _connectionBloc;
  LiveNetwork _liveNetwork;
  String buttonText = 'null';

  // ignore: non_constant_identifier_names
  Size get ScreenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectionBloc = ConnectionBloc(ConnectionInitialState());
    _liveNetwork = LiveNetwork(connectionBloc: _connectionBloc)..listen();

    Log.t('zerky initState()');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Log.t('zerky afterFirstLayout()');
    _liveNetwork.connectionType().then((value) {
      if (value.toString() != buttonText) {
        setState(() {
          buttonText = value.toString();
        });
      }
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Log.t('zerky didChangeDependencies()');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.t('zerky didChangeAppLifecycleState ${state.toString()}');
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    ModeTheme.of(context).setBrightness(brightness);
    Log.t('zerky didChangePlatformBrightness ${brightness.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    Log.t('zerky build()');
    return HudScaffold.progressText(
      context,
      hide: hideSpinner,
      indicatorColors: ModeColor(light: Colors.purpleAccent, dark: Colors.greenAccent),
      progressText: 'Zerky Showable spinner',
      scaffold: Scaffold(
        appBar: AppBar(
          title: Text('Title: zerky'),
        ),
        body: body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              hideSpinner = false;
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  hideSpinner = true;
                });
              });
            });
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    Log.t('zerky didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    Log.t('zerky deactivate()');
    super.deactivate();
  }

  @override
  void dispose() {
    Log.t('zerky dispose()');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Scaffold body
  Widget body() {
    Log.t('zerky body()');
    return BlocBuilder(
      cubit: _connectionBloc,
      builder: (context, state) {
        if (state is ConnectedWifiState) {
          return Center(child: Text('WIFI'));
        }
        if (state is ConnectedCelluarState) {
          return Center(child: Text('Celluar'));
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Zerky Template', style: Theme.of(context).textTheme.headline5),
              ElevatedButton(
                child: Text(
                  'Toggle Mode',
                  style: TextStyle(fontSize: 32.0),
                ),
                onPressed: () {
                  ModeTheme.of(context).toggleBrightness();
                },
              ),
              ElevatedButton(
                child: Text('$buttonText', style: Theme.of(context).textTheme.headline5),
                onPressed: () {
                  _liveNetwork.connectionType().then((value) {
                    if (value.toString() != buttonText) {
                      setState(() {
                        buttonText = value.toString();
                      });
                    }
                  });
                  final bar = _message(context, buttonText);
                  ScaffoldMessenger.of(context).showSnackBar(bar);

                  /// Navigator.push(context, MaterialPageRoute(builder: (context) => Berky()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _message(BuildContext context, String message) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
}
