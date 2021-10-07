import 'package:flutter/material.dart';
import 'package:tcc_app/providers/screens/agenda/agenda-dia.dart';
import 'package:tcc_app/screens/agenda/widgets/fab.dart';
import 'package:tcc_app/screens/agenda/widgets/menu-agenda.dart';
import 'package:calendar_views/day_view.dart';
import 'package:provider/provider.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

class AgendaDia extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgendaDiaProvider>(
        create: (context) => AgendaDiaProvider(context),
        child: Consumer<AgendaDiaProvider>(
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
                  MenuAgenda('Dia')
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
  const ScrollWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaDiaProvider>(builder: (context, model, widget) {
      return InfiniteList(
          key: Key(model.settings.scrollDirection.toString()),
          scrollDirection: model.settings.scrollDirection,
          anchor: model.settings.anchor,
          controller: model.scrollController,
          direction: model.settings.multiDirection
              ? InfiniteListDirection.single
              : InfiniteListDirection.multi,
          builder: (context, index) {
            

            List<DateTime> dates = [];
            DateTime date;

            if (index < 0) {
              int x = (index * -1) ;
              date = DateTime.now().subtract(Duration(days: x));
            } else {
              date = DateTime.now().add(Duration(days: (index)));
            }

            dates.add(date);
            
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
                        child: model.renderDays(date, dates, context))),
                minOffsetProvider: (state) => 80);
          });
    });
  }
}
