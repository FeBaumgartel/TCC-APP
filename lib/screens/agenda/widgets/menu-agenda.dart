import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/screens/agenda/agenda.dart';
import 'package:tcc_app/screens/agenda/agenda-mes.dart';
import 'package:tcc_app/screens/agenda/agenda-dia.dart';

import '../agenda-semana.dart';

class MenuAgenda extends StatefulWidget {
  final String paginaAtual;

  MenuAgenda(this.paginaAtual);
  @override
  _MenuAgenaState createState() => _MenuAgenaState();
}

class CustomPopupMenu {
  int? value;
  String? title;
  IconData? icon;
  CustomPopupMenu({this.title, this.value, this.icon});
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Agenda', value: 1, icon: FontAwesomeIcons.calendar),
  CustomPopupMenu(title: 'Mês', value: 2, icon: FontAwesomeIcons.calendarAlt),
  CustomPopupMenu(
      title: 'Semana', value: 3, icon: FontAwesomeIcons.calendarWeek),
  CustomPopupMenu(title: 'Dia', value: 4, icon: FontAwesomeIcons.calendarDay),
];

class _MenuAgenaState extends State<MenuAgenda> {
  CustomPopupMenu? _selectedChoices;

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
    if (_selectedChoices!.value == 1) {
      _routeVerifier(Agenda());
    } else if (_selectedChoices!.value == 2) {
      _routeVerifier(AgendaMes());
    } else if (_selectedChoices!.value == 3) {
      _routeVerifier(AgendaSemana());
    } else if (_selectedChoices!.value == 4) {
      _routeVerifier(AgendaDia());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CustomPopupMenu>(
      elevation: 3.2,
      onCanceled: () {},
      onSelected: _select,
      itemBuilder: (BuildContext context) {
        return choices.map((CustomPopupMenu choice) {
          return PopupMenuItem<CustomPopupMenu>(
            value: choice,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(choice.icon, color: Colors.grey, size: 19),
                  Text(
                    "  " + choice.title!,
                    //style: TextStyle(color: Colors.white, fontSize: 30),
                  )
                ]),
          );
        }).toList();
      },
    );
  }

  _routeVerifier(Widget route) {
    if (widget.paginaAtual == 'Mês' && _selectedChoices!.value != 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => route),
      );
    } else if (_selectedChoices!.value == 2) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => route),
          ModalRoute.withName('/home'));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => route),
      );
    }
  }
}
