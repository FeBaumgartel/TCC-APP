import 'package:flutter/material.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/providers/components/drawer.dart';
import 'package:tcc_app/providers/sessao.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tcc_app/services/sessao.dart';

class DrawerApp extends StatelessWidget {
  final Sessao _sessao = Sessao.create();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DrawerProvider>(
          create: (context) => DrawerProvider(context),
        )
      ],
      child: Consumer<DrawerProvider>(
        builder: (context, model, widget) => Drawer(
          key: model.drawerKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
                child: DrawerHeader(
                  padding: EdgeInsets.all(15),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.usuario != null ? model.usuario?.nome : '',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ItemDrawer(
                nome: 'Agenda',
                rota: '/agenda',
                icone: FontAwesomeIcons.solidCalendarAlt,
              ),
              Divider(
                height: 1,
              ),
              ItemDrawer(
                nome: 'Hinos',
                rota: '/hinos',
                icone: FontAwesomeIcons.music,
              ),
              Divider(
                height: 1,
              ),
              if (model.usuario != null && model.usuario.tipo == 1)
                ItemDrawer(
                  nome: 'Grupos',
                  rota: '/grupos',
                  icone: FontAwesomeIcons.users,
                ),
              if (model.usuario != null && model.usuario.tipo == 1)
              Divider(
                height: 1,
              ),
              if (model.usuario != null && model.usuario.tipo == 2)
              ItemDrawer(
                nome: 'Meu Perfil',
                rota: '/perfil',
                icone: FontAwesomeIcons.user,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 15,
                ),
                trailing: Consumer<DrawerProvider>(
                  builder: (context, model, widget) {
                    return Text((model.packageInfo != null)
                        ? 'Versão: ' + model.packageInfo.version
                        : '');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDrawer extends StatelessWidget {
  final IconData icone;
  final String nome;
  final String rota;

  ItemDrawer({this.icone, this.nome, this.rota});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 15,
      ),
      leading: Icon(
        icone,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(nome),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, rota);
      },
    );
  }
}
