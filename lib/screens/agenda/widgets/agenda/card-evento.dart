import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/providers/screens/agenda/agenda.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda/settings.dart';
import 'package:provider/provider.dart';

class CardEvento extends StatelessWidget {
  final int index;
  final List<Evento> eventos;
  final Settings settings;
  final String hora;
  const CardEvento(this.index, this.eventos, this.settings, this.hora,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaProvider>(builder: (context, model, widget) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CadastrarEditarEvento(eventoParam: eventos[index])))
              .then((value) => model.refresh());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF825EE4).withOpacity(0.26),
          ),
          margin: settings.contentMargin,
          padding: EdgeInsets.all(16),
          width: settings.contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eventos[index].nome as String,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              Divider(
                color: Colors.transparent,
                height: 5,
              ),
              Text(
                hora,
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );
    });
  }
}
