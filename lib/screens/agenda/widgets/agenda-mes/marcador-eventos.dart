import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;

class MarcadorEventos extends StatelessWidget {
  final CalendarController calendarController;
  final DateTime date;
  final List<Evento> events;
  const MarcadorEventos(this.calendarController, this.date, this.events,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? numEvents = events.length > 0 ? events.length : null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: calendarController.isSelected(date) ||
              calendarController.isToday(date)
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: calendarController.isSelected(date)
                  ? Theme.of(context).hintColor
                  : calendarController.isToday(date)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor,
            )
          : null,
      width: 17.0,
      height: 17.0,
      child: Center(
          child: Container(
        padding: EdgeInsets.only(
          bottom: 1,
        ),
        decoration: BoxDecoration(
            border: calendarController.isSelected(date) ||
                    calendarController.isToday(date)
                ? null
                : Border(
                    bottom: BorderSide(
                    color: date.weekday == 7
                        ? ThemeApp.Theme.primary
                        : date.weekday == 6
                            ? ThemeApp.Theme.primary
                            : Colors.black,
                    width: 1.0,
                  ))),
        child: Text('$numEvents',
            style: TextStyle().copyWith(
              color: calendarController.isSelected(date) ||
                      calendarController.isToday(date)
                  ? Theme.of(context).primaryColorLight
                  : date.weekday == 7
                      ? ThemeApp.Theme.primary
                      : date.weekday == 6
                          ? ThemeApp.Theme.primary
                          : Colors.black,
              fontSize: 10.0,
            )),
      )),
    );
  }
}
