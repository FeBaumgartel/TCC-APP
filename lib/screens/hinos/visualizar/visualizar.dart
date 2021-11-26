import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/models/hino.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/services/sessao.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;
import 'package:tcc_app/screens/hinos/visualizar/widgets/fade_on_scroll.dart';
import 'package:tcc_app/services/dao/hinos.dart';
import './widgets/fade_on_scroll.dart';

class Visualizar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new VisualizarPage(context);
  }
}

class VisualizarPage extends StatefulWidget {
  final context;
  VisualizarPage(this.context, {Key key}) : super(key: key);

  @override
  _VisualizarPageState createState() => _VisualizarPageState();
}

class _VisualizarPageState extends State<VisualizarPage> {
  final ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _hinosService = HinosService();
  Future<List<Widget>> _future;
  List<Widget> _widgets = List<Widget>();
  dynamic _arguments;
  bool exibe = false;
  Usuario usuario;

  @override
  void initState() {
    super.initState();
    _arguments = ModalRoute.of(widget.context).settings.arguments;
    _future = _build(_arguments.id);
  }

  Future<List<Widget>> _build(int id) async {
    final Sessao _sessao = Sessao.create();

    _sessao.getUsuario().then((usuario) {
      this.usuario = usuario;
      if (usuario != null && usuario.tipo == 1) exibe = true;
    });

    _widgets = new List<Widget>();

    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Widget>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            body: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(pinned: true, title: Text(_arguments.nome)),
                  SliverFillRemaining(
                    child: ListView(
                      padding: EdgeInsets.only(top: 5),
                      children: <Widget>[
                        if (_arguments.letra != null &&
                            _arguments.letra.replaceAll(" ", "") != "")
                          Container(
                            padding: EdgeInsets.only(left: 69, right: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _arguments.letra,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ]),
            floatingActionButton: _bottomButtons(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _bottomButtons() {
    return Visibility(visible: exibe, child: _renderSpeedDial());
  }

  SpeedDial _renderSpeedDial() {
    List<SpeedDialChild> children = [
      SpeedDialChild(
        child: Icon(FontAwesomeIcons.pencilAlt, color: Colors.grey[600]),
        onTap: () => Navigator.pushNamed(
          context,
          '/hinos/cadastrar',
          arguments: <String, dynamic>{"hino": _arguments},
        ).then(
          (value) => setState(
            () {
              _future = _build(_arguments.id);
            },
          ),
        ),
        backgroundColor: Colors.white,
      ),
      SpeedDialChild(
        child: Icon(FontAwesomeIcons.trash, color: Colors.grey[600]),
        onTap: () => _showAlertExcluir(),
        backgroundColor: Colors.white,
      ),
    ];

    if (children.isEmpty) {
      return null;
    }

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0,
      children: children,
    );
  }

  Future<void> _excluir() async {
    try {
      await _hinosService.delete(_arguments.id);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Houve um problema ao excluir o hino!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showAlertExcluir() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir hino'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text.rich(TextSpan(
                  children: [
                    TextSpan(text: 'Deseja mesmo'),
                    TextSpan(
                      text: ' excluir ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'esse hino?'),
                  ],
                ))
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            MaterialButton(
              child: Text('Excluir'),
              onPressed: () => _excluir(),
            ),
          ],
        );
      },
    );
  }
}
