import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/providers/screens/agenda/agenda-mes.dart';
import 'package:tcc_app/screens/agenda/widgets/fab.dart';
import 'package:tcc_app/screens/agenda/widgets/menu-agenda.dart';
import 'package:provider/provider.dart';

class AgendaMes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AgendaMesPage();
  }
}

class AgendaMesPage extends StatefulWidget {
  AgendaMesPage({Key key}) : super(key: key);

  @override
  _AgendaMesPageState createState() => _AgendaMesPageState();
}

class _AgendaMesPageState extends State<AgendaMesPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgendaMesProvider>(
        create: (context) => AgendaMesProvider(context, _animationController),
        child: Consumer<AgendaMesProvider>(builder: (context, model, widget) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Agenda'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Hoje', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    model.goToToday();
                  },
                ),
                MenuAgenda('Mês')
              ],
            ),
            body: new FutureBuilder<List<Evento>>(
              future: model.build(),
              builder:
                (BuildContext context, AsyncSnapshot<List<Evento>> snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    model.buildTableCalendarWithBuilders(
                        model.events(snapshot.data)),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: model
                                .buildEventList(model.events(snapshot.data)),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: Fab(model.cadastrarEvento, false),
          );
        }));
  }
}
