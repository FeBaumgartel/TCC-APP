import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda/card-evento.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda/settings.dart';
import 'package:tcc_app/services/dao/eventos.dart';
import 'package:intl/date_symbol_data_local.dart';

class AgendaProvider extends ChangeNotifier {
  final BuildContext context;
  final EventosService _eventosService = new EventosService();
  ScrollController scrollController;
  Settings settings = Settings();
  List<int> _tiposFiltro = []; //variavel do filtro tipo
  List<int> _usersFiltro = []; //variavel do filtro users
  String _pesquisa;

  AgendaProvider(this.context) {
    initializeDateFormatting("pt_BR");
    scrollController = ScrollController();
    _tiposFiltro = [];
    _usersFiltro = [];
    _pesquisa = "";
  }

  refresh() => notifyListeners();

  pesquisar(String pesquisado) async {
    _pesquisa = pesquisado;
    notifyListeners();
  }

  buildAgenda(String data) {
    EventosService eventosService = new EventosService();
    return eventosService.getEventsDate(
        data, _tiposFiltro, _usersFiltro, _pesquisa);
  }

  List<Widget> buildEvents(List<Evento> eventos, BuildContext context) {
    List<Widget> evs = [];
    for (var i = 0; i < eventos.length; i++) {
      //Evento event = eventos[i];
      var temp = eventos[i].dataInicio.split(" ");
      var hora = temp[1];
      temp = hora.split(":");
      hora = temp[0] + ":" + temp[1];
      evs.add(
        CardEvento(i, eventos, settings, hora)
      );
    }
    return evs;
  }

  cadastrarEvento() {
    Evento _evento = Evento();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastrarEditarEvento(eventoParam: _evento, atendimento: false,)),
    ).then((value) => notifyListeners());
  }
}
