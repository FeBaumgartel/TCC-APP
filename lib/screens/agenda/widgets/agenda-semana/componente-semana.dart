import 'package:calendar_views/calendar_views.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-semana/cabecalho-semana.dart';
import 'package:tcc_app/services/dao/eventos.dart';

class ComponenteSemana extends StatelessWidget {
  final List<Evento> events;
  final DateTime date;
  final EventosService eventosService;
  final List<DateTime> datas;
  final List<int> tiposFiltro;
  final List<int> usersFiltro;
  final Iterable<StartDurationItem> Function(DateTime) getEventsOfDay;

  const ComponenteSemana(
    this.events,
    this.date,
    this.eventosService,
    this.datas,
    this.tiposFiltro,
    this.usersFiltro,
    this.getEventsOfDay, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          child: Text(
            DateFormat("MMMM 'de' y", "pt_BR").format(date).toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(5),
          color: Theme.of(context).primaryColor.withOpacity(0.12),
          width: MediaQuery.of(context).size.width <= 360
              ? 780
              : MediaQuery.of(context).size.width,
        ),
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.12),
          child: DayViewDaysHeader(
            headerItemBuilder: _headerItemBuilder,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<Evento>>(
                future: eventosService.getEventsWeek(
                    datas, tiposFiltro, usersFiltro),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Evento>> snap) {
                  if (snap.hasData) {
                    if (snap.data != null) {
                      _gerenciaEventos(snap.data);
                      return DayViewSchedule(
                        heightPerMinute: 1.0,
                        components: <ScheduleComponent>[
                          TimeIndicationComponent.intervalGenerated(
                            generatedTimeIndicatorBuilder:
                                _generatedTimeIndicatorBuilder,
                          ),
                          SupportLineComponent.intervalGenerated(
                            generatedSupportLineBuilder:
                                _generatedSupportLineBuilder,
                          ),
                          DaySeparationComponent(
                            generatedDaySeparatorBuilder:
                                _generatedDaySeparatorBuilder,
                          ),
                          EventViewComponent(
                            getEventsOfDay: getEventsOfDay,
                          ),
                        ],
                      );
                    } else {
                      return DayViewSchedule(
                        heightPerMinute: 1.0,
                        components: <ScheduleComponent>[
                          TimeIndicationComponent.intervalGenerated(
                            generatedTimeIndicatorBuilder:
                                _generatedTimeIndicatorBuilder,
                          ),
                          SupportLineComponent.intervalGenerated(
                            generatedSupportLineBuilder:
                                _generatedSupportLineBuilder,
                          ),
                          DaySeparationComponent(
                            generatedDaySeparatorBuilder:
                                _generatedDaySeparatorBuilder,
                          ),
                        ],
                      );
                    }
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height - 180,
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
          ),
        ),
      ],
    ));
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return CabecalhoSemana(day: day);
  }

  _gerenciaEventos(Iterable<Evento>? _eventosConsulta) {
    List<Evento> _tempEvents = [];

    if (events.isEmpty) {
      events.addAll(_eventosConsulta!);
    } else {
      _eventosConsulta!.forEach((_event) {
        if (!_containsEvent(events, _event)) _tempEvents.add(_event);
      });
      events.addAll(_tempEvents);
    }
  }

  _containsEvent(List<Evento> listEvents, Evento checkEvent) {
    bool contains = false;
    listEvents.forEach((evento) {
      if (evento.id == checkEvent.id) contains = true;
    });
    return contains;
  }

  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return Positioned(
      top: itemPosition.top - 10,
      left: itemPosition.left,
      width: itemSize.width - 20,
      height: itemSize.height,
      child: Container(
        child: Center(
          child: Text(_minuteOfDayToHourMinuteString(minuteOfDay),
              style: TextStyle(color: Colors.grey[400])),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    return Positioned(
      top: itemPosition.top - 12,
      left: itemPosition.left,
      width: itemWidth,
      child: Container(
        height: 0.7,
        color: Colors.grey[300],
      ),
    );
  }

  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return Positioned(
      top: itemPosition.top - 12,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: Center(
        child: Container(
          width: 0.7,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }
}
