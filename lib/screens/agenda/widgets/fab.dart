import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;

class Fab extends StatelessWidget {
  Fab(this.cadastrarEvento, this.att);
  final Function cadastrarEvento;
  final bool att;
  @override
    Widget build(BuildContext context){
      return FloatingActionButton(
        onPressed: () {
          cadastrarEvento();
        },
        child: Icon(FontAwesomeIcons.plus, size: 20),
        backgroundColor: ThemeApp.Theme.primary,
      );
    }

}