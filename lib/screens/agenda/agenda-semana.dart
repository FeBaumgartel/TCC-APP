import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/providers/screens/agenda/agenda-semana.dart';
import 'package:tcc_app/screens/agenda/widgets/fab.dart';
import 'package:tcc_app/screens/agenda/widgets/menu-agenda.dart';
import 'package:calendar_views/day_view.dart';
import 'package:provider/provider.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

class AgendaSemana extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgendaSemanaProvider>(
        create: (context) => AgendaSemanaProvider(context),
        child: Consumer<AgendaSemanaProvider>(
          builder: (context, model, widget) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Agenda'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Hoje', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      model.scrollController.jumpTo(0);
                    },
                  ),
                  MenuAgenda('Semana')
                ],
              ),
              body: ScrollWidget(),
              floatingActionButton: Fab(model.cadastrarEvento, false),
            );
          },
        ));
  }
}

class ScrollWidget extends StatelessWidget {
  const ScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaSemanaProvider>(builder: (context, model, widget) {
      return InfiniteList(
          key: Key(model.settings.scrollDirection.toString()),
          scrollDirection: model.settings.scrollDirection,
          anchor: model.settings.anchor,
          controller: model.scrollController,
          direction: model.settings.multiDirection
              ? InfiniteListDirection.single
              : InfiniteListDirection.multi,
          minChildCount: model.settings.minCount,
          maxChildCount: model.settings.maxCount,
          builder: (context, index) {
            DateTime _day0;
            DateTime _day1;
            DateTime _day2;
            DateTime _day3;
            DateTime _day4;
            DateTime _day5;
            DateTime _day6;

            List<DateTime> dates = [];
            DateTime date;
            int semana = 7;

            if (index < 0) {
              int x = (index * -1) * semana;
              date = DateTime.now().subtract(Duration(days: x));
            } else {
              date = DateTime.now().add(Duration(days: (index * semana)));
            }

            if (date.weekday == 0) {
              //Domingo
              _day0 = date;
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date.add(Duration(days: 1));
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date.add(Duration(days: 2));
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date.add(Duration(days: 3));
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date.add(Duration(days: 4));
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date.add(Duration(days: 5));
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date.add(Duration(days: 6));
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            } else if (date.weekday == 1) {
              //Segunda
              _day0 = date.subtract(Duration(days: 1));
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date;
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date.add(Duration(days: 1));
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date.add(Duration(days: 2));
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date.add(Duration(days: 3));
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date.add(Duration(days: 4));
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date.add(Duration(days: 5));
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            } else if (date.weekday == 2) {
              //Terça
              _day0 = date.subtract(Duration(days: 2));
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date.subtract(Duration(days: 1));
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date;
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date.add(Duration(days: 1));
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date.add(Duration(days: 2));
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date.add(Duration(days: 3));
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date.add(Duration(days: 4));
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            } else if (date.weekday == 3) {
              //Quarta
              _day0 = date.subtract(Duration(days: 3));
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date.subtract(Duration(days: 2));
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date.subtract(Duration(days: 1));
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date;
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date.add(Duration(days: 1));
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date.add(Duration(days: 2));
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date.add(Duration(days: 3));
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            } else if (date.weekday == 4) {
              //Quinta
              _day0 = date.subtract(Duration(days: 4));
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date.subtract(Duration(days: 3));
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date.subtract(Duration(days: 2));
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date.subtract(Duration(days: 1));
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date;
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date.add(Duration(days: 1));
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date.add(Duration(days: 2));
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            } else if (date.weekday == 5) {
              //Sexta
              _day0 = date.subtract(Duration(days: 5));
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date.subtract(Duration(days: 4));
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date.subtract(Duration(days: 3));
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date.subtract(Duration(days: 2));
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date.subtract(Duration(days: 1));
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date;
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date.add(Duration(days: 1));
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            } else if (date.weekday == 6) {
              //Sábado
              _day0 = date.subtract(Duration(days: 6));
              dates.add(DateTime(_day0.year, _day0.month, _day0.day));
              _day1 = date.subtract(Duration(days: 5));
              dates.add(DateTime(_day1.year, _day1.month, _day1.day));
              _day2 = date.subtract(Duration(days: 4));
              dates.add(DateTime(_day2.year, _day2.month, _day2.day));
              _day3 = date.subtract(Duration(days: 3));
              dates.add(DateTime(_day3.year, _day3.month, _day3.day));
              _day4 = date.subtract(Duration(days: 2));
              dates.add(DateTime(_day4.year, _day4.month, _day4.day));
              _day5 = date.subtract(Duration(days: 1));
              dates.add(DateTime(_day5.year, _day5.month, _day5.day));
              _day6 = date;
              dates.add(DateTime(_day6.year, _day6.month, _day6.day));
            }
            return InfiniteListItem(
                contentBuilder: (context) => Container(
                    width: MediaQuery.of(context).size.width <= 360
                        ? 780
                        : MediaQuery.of(context).size.width,
                    child: DayViewEssentials(
                        widths: DayViewWidths(
                            daySeparationAreaWidth: 10,
                            totalAreaStartPadding: 0.2,
                            timeIndicationAreaWidth: 55,
                            separationAreaWidth: 0,
                            mainAreaStartPadding: 2),
                        properties: DayViewProperties(
                          days: dates,
                        ),
                        child: model.renderWeeks(date, dates))),
                minOffsetProvider: (state) => 80);
          });
    });
  }
}
