import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/cadastrar-editar.dart';

class ListaEventos extends StatelessWidget {
  final Map<DateTime, List<Evento>> eventos;
  final DateTime selectedDay;
  const ListaEventos(this.eventos, this.selectedDay, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: eventos[selectedDay]
            .map((eventos) => Container(
                decoration: BoxDecoration(
                  color: Color(0xFF825EE4).withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Theme(
                  data: ThemeData(splashColor: Colors.white),
                  child: ListTile(
                      title: Text(eventos.nome,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                          DateFormat('dd/MM  HH:mm', 'pt_BR')
                              .format(DateTime.parse(eventos.data)),
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CadastrarEditarEvento(eventoParam: eventos)),
                        );
                      }),
                )))
            .toList(),
      );
  }
}