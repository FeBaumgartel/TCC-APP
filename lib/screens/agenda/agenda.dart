import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/components/app-bar.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/providers/screens/agenda/agenda.dart';
import 'package:tcc_app/screens/agenda/widgets/fab.dart';
import 'package:tcc_app/screens/agenda/widgets/menu-agenda.dart';
import 'package:provider/provider.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';
import 'package:intl/intl.dart'; //funções da data

class Agenda extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgendaProvider>(
        create: (context) => AgendaProvider(context),
        child: Consumer<AgendaProvider>(builder: (context, model, widget) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                AppBarComponent(
                  title: Text('Agenda'),
                  onChange: (value) {
                    model.pesquisar(value);
                  },
                  onClose: () {
                    model.pesquisar('');
                  },
                  actions: <Widget>[
                    FlatButton(
                      child:
                          Text('Hoje', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        model.scrollController!.jumpTo(0);
                      },
                    ),
                    MenuAgenda('Agenda')
                  ],
                ),
                SliverFillRemaining(
                  child: ScrollWidget(),
                ),
              ],
            ),
            floatingActionButton: Fab(model.cadastrarEvento, false),
          );
        }));
  }
}

class ScrollWidget extends StatelessWidget {
  const ScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaProvider>(builder: (context, model, widget) {
      return InfiniteList(
        key: Key(model.settings.scrollDirection.toString()),
        scrollDirection: model.settings.scrollDirection,
        anchor: model.settings.anchor,
        controller: model.scrollController,
        direction: model.settings.multiDirection
            ? InfiniteListDirection.multi
            : InfiniteListDirection.single,
        minChildCount: model.settings.minCount,
        maxChildCount: model.settings.maxCount,
        builder: (context, index) {
          final date = DateTime.now().add(Duration(
            days: index,
          ));

          String data = date.toString();
          var temp = data.split(' ');
          data = temp[0];
          return InfiniteListItem(
            headerAlignment: model.settings.alignment,
            headerStateBuilder: (context, state) => Container(
              height: 70,
              width: 70,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    // data 06
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    //mes Fev
                    DateFormat.MMM("pt_BR").format(date),
                    style: TextStyle(
                      height: .7,
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            contentBuilder: (context) => FutureBuilder<List<Evento>>(
                future: model.buildAgenda(data),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Evento>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return Column(
                        children: model.buildEvents(snapshot.data, context),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.16),
                        ),
                        margin: model.settings.contentMargin,
                        padding: EdgeInsets.all(16),
                        width: model.settings.contentWidth,
                        height: 70,
                        child: Center(
                          child: Text(
                            'Nenhum evento!',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[500]),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.transparent),
                    ));
                  }
                }),
            minOffsetProvider: (state) => 0,
          );
        },
      );
    });
  }
}
