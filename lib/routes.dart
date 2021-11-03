import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tcc_app/screens/login/login.dart';
import 'package:tcc_app/screens/agenda/agenda.dart';
import 'package:tcc_app/screens/hinos/hinos.dart';
import 'package:tcc_app/screens/home/home.dart';
import 'package:tcc_app/screens/landing-page.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';



class Routes {
  final routes = <String, WidgetBuilder>{
    '/login': (BuildContext context) => Login(),
    '/home': (BuildContext context) => Home(),
    '/landingpage': (BuildContext context) => LandingPage(),
    '/agenda': (BuildContext context) => Agenda(),
    '/hinos': (BuildContext context) => Hinos(),
  };


  Routes() {
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {  
          return ThemeNotifier(ThemeApp.Theme.defaultTheme);  
        },
        child: OverlaySupport(
          child: TccApp(routes: routes),
        ),
      ),
    );
  }
}

class TccApp extends StatelessWidget {

  const TccApp({
    Key key,
    this.routes,
  }) : super(key: key);

  final Map routes;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return new MaterialApp(
      theme: themeNotifier.getTheme(),
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        return routes['/home'];
      },
      home: new Login(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}