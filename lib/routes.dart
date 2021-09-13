import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tcc_app/screens/login/login.dart';
import 'package:tcc_app/screens/agenda/agenda.dart';
// import 'package:biribi_financas/screens/principal/principal.dart';
// import 'package:biribi_financas/screens/movimentacao/movimentacao.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';



class Routes {
  final routes = <String, WidgetBuilder>{
    '/login': (BuildContext context) => Login(),
    '/agenda': (BuildContext context) => Agenda(),
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
    Key? key,
    required this.routes,
  }) : super(key: key);

  final Map<String, Widget Function(BuildContext)> routes;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return new MaterialApp(
      theme: themeNotifier.getTheme(),
      routes: routes,
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