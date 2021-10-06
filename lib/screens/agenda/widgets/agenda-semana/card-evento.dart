import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/providers/screens/agenda/agenda-semana.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:provider/provider.dart';

class CardEvento extends StatelessWidget {
  final Evento event;

  const CardEvento({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaSemanaProvider>(builder: (context, model, widget) {
      return InkWell(
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CadastrarEditarEvento(eventoParam: event)))
              .then((value) => model.refresh());
        },
        child: Container(
          margin: EdgeInsets.only(left: 0.5, right: 0.5, bottom: 0.5, top: 0.5),
          padding: MediaQuery.of(context).size.width <= 360
              ? EdgeInsets.all(0.3)
              : EdgeInsets.all(0.5),
          color: Color(0xFF825EE4).withOpacity(0.16),
          child: Text("${event.nome}", style: TextStyle(color: Colors.white)),
        ),
      );
    });
  }
}
