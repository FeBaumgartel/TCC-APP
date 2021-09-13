import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaSelecionado extends StatelessWidget {
  final AnimationController animationController;
  final DateTime date;
  final CalendarController calendarController;
  const DiaSelecionado(
      this.animationController, this.date, this.calendarController,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.2, end: 1.0).animate(animationController),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        margin: const EdgeInsets.all(4.0),
        width: 40,
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle().copyWith(
                fontSize: 16.0,
                color: calendarController.isSelected(date)
                    ? Colors.white
                    : Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
