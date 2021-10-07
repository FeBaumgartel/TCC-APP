
import 'package:calendar_views/calendar_views.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-dia/card-evento.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-dia/componente-dia.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-semana/settings.dart';
import 'package:tcc_app/services/dao/eventos.dart';

class AgendaDiaProvider extends ChangeNotifier {
  final BuildContext context;
  List<Evento> events = [];
  final ScrollController scrollController = ScrollController();
  Settings settings = Settings();

  AgendaDiaProvider(this.context) {
    initializeDateFormatting();
  }

  refresh() {
    this.events.clear();
    notifyListeners();
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    Map<DateTime, List<Evento>> _evs = Map<DateTime, List<Evento>>();
    List<StartDurationItem> _events = [];
    _evs = eventos(events);
    if (_evs[day] != null) {
      _events = _evs[day]
          .map(
            (event) => StartDurationItem(
              startMinuteOfDay: (DateTime.parse(event.dataInicio).hour * 60) +
                  DateTime.parse(event.dataInicio).minute,
              duration: ((DateTime.parse(event.dataFinal).hour * 60) +
                          DateTime.parse(event.dataFinal).minute -
                          (DateTime.parse(event.dataInicio).hour * 60) +
                          DateTime.parse(event.dataInicio).minute) <
                      0
                  ? 60
                  : ((DateTime.parse(event.dataFinal).hour * 60) +
                      DateTime.parse(event.dataFinal).minute -
                      (DateTime.parse(event.dataInicio).hour * 60) +
                      DateTime.parse(event.dataInicio).minute),
              builder: (context, itemPosition, itemSize) => _eventBuilder(
                context,
                itemPosition,
                itemSize,
                event,
              ),
            ),
          )
          .toList();
    }
    return _events;
  }

  eventos(List<Evento> eventos) {
    Map<DateTime, List<Evento>> _events = Map<DateTime, List<Evento>>();
    for (Evento e in eventos) {
      DateTime data = DateTime.parse(e.data);
      if (!(_events.containsKey(data))) {
        _events[data] = [];
      }
      _events[data].add(e);
    }
    return _events;
  }

  Positioned _eventBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    Evento event,
  ) {
    return Positioned(
        top: itemPosition.top,
        left: itemPosition.left,
        width: itemSize.width,
        height: itemSize.height,
        child: CardEvento(event));
  }

  Widget renderDays(DateTime date, List<DateTime> datas, BuildContext context) {
    EventosService eventosService = EventosService();
    return ComponenteDia(events, date, eventosService, datas, _getEventsOfDay);
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
