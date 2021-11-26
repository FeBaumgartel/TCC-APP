import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/components/drawer.dart';
import 'package:tcc_app/providers/screens/home.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new HomePage();
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(context),
      child: Scaffold(
        backgroundColor: Color(0xFFF0F2F8),
        body: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 161,
              title: Padding(
                padding: EdgeInsets.only(right: 56),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          height: 30,
                          width: 200,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GestureDetector(
                        onTap: () => {Navigator.pushNamed(context, '/agenda')},
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 15,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.calendarCheck,
                                    size: 20, color: ThemeApp.Theme.primary),
                                Consumer<HomeProvider>(
                                    builder: (context, model, widget) {
                                  return Text(model.atividades);
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
                      child: Consumer<HomeProvider>(
                        builder: (context, model, widget) => Row(
                          children: <Widget>[
                            model.renderGridItemLinha('Hinos', '/hinos',
                                icone: FontAwesomeIcons.music),
                            if (model.usuario != null &&
                                model.usuario.tipo == 1)
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0)),
                            if (model.usuario != null &&
                                model.usuario.tipo == 1)
                              model.renderGridItemLinha('Grupos', '/grupos',
                                  icone: FontAwesomeIcons.users),
                            if (model.usuario != null &&
                                model.usuario.tipo == 2)
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0)),
                            if (model.usuario != null &&
                                model.usuario.tipo == 2)
                              model.renderGridItemLinha('Meu Perfil', '/perfil',
                                  icone: FontAwesomeIcons.user)
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16.0))
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: DrawerApp(),
      ),
    );
  }
}
