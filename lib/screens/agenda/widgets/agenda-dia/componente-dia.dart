import 'package:calendar_views/calendar_views.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-dia/cabecalho-dia.dart';
import 'package:tcc_app/services/dao/eventos.dart';

class ComponenteDia extends StatelessWidget {
  final List<Evento> events;
  final DateTime date;
  final EventosService eventosService;
  final List<DateTime> datas;
  final Iterable<StartDurationItem> Function(DateTime) getEventsOfDay;

  const ComponenteDia(this.events, this.date, this.eventosService, this.datas, this.getEventsOfDay,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          child: DayViewDaysHeader(
            headerItemBuilder: _headerItemBuilder,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<Evento>>(
                future: eventosService.getEventsWeek(
                    datas),
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
    );
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return CabecalhoDia(day);
  }

  _gerenciaEventos(List<Evento> _eventosConsulta) {
    List<Evento> _tempEvents = [];

    if (events.isEmpty) {
      events.addAll(_eventosConsulta);
    } else {
      _eventosConsulta.forEach((_event) {
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
