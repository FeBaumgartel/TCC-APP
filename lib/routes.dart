import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tcc_app/screens/hinos/cadastrar-editar/cadastrar-editar.dart'
    as HinoCadastrarEditar;
import 'package:tcc_app/screens/hinos/visualizar/visualizar.dart'
    as HinoVisualizar;
import 'package:tcc_app/screens/grupos/cadastrar-editar/cadastrar-editar.dart'
    as GrupoCadastrarEditar;
import 'package:tcc_app/screens/grupos/visualizar/visualizar.dart'
    as GrupoVisualizar;
import 'package:tcc_app/screens/login/login.dart';
import 'package:tcc_app/screens/agenda/agenda.dart';
import 'package:tcc_app/screens/hinos/hinos.dart';
import 'package:tcc_app/screens/grupos/grupos.dart';
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
    '/hinos/cadastrar': (BuildContext context) => HinoCadastrarEditar.CadastrarEditar(),
    '/hinos/visualizar': (BuildContext context) =>
        HinoVisualizar.Visualizar(),
    '/grupos': (BuildContext context) => Grupos(),
    '/grupos/cadastrar': (BuildContext context) => GrupoCadastrarEditar.CadastrarEditar(),
    '/grupos/visualizar': (BuildContext context) =>
        GrupoVisualizar.Visualizar(),
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