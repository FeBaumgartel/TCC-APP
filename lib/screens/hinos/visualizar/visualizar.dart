import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/models/hino.dart';
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
  int _selectedIndex = 0;
  Hino _hino;
  Future<List<Widget>> _future;
  List<Widget> _widgets = List<Widget>();
  dynamic _arguments;
  bool _podeEditar = false;

  @override
  void initState() {
    super.initState();
    _arguments = ModalRoute.of(widget.context).settings.arguments;
    _future = _build(_arguments.idLocal);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = (index == 1) ? 0 : index;
      _future = _build(_arguments.idLocal);
    });
  }

  Future<Hino> _getHino(int id) async {
    _hino = await _hinosService.getHino(id);

    return _hino;
  }

  Future<List<Widget>> _build(int id) async {
    _widgets = new List<Widget>();

    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Widget>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.hasData) {
          List<Widget> loaded = snapshot.data;
          return Scaffold(
            key: _scaffoldKey,
            body: CustomScrollView(controller: _scrollController, slivers: <
                Widget>[
              SliverAppBar(
                  pinned: true,
                  expandedHeight: 170,
                  title: Text(_arguments.nomeFantasia),
                  flexibleSpace: FadeOnScroll(
                      scrollController: _scrollController,
                      fullOpacityOffset: 50,
                      child: Stack(
                        children: <Widget>[
                          if (_arguments.razaoSocial != null &&
                              _arguments.razaoSocial.replaceAll(" ", "") != "")
                            Container(
                              padding: EdgeInsets.only(left: 69, right: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _arguments.razaoSocial,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          if (_arguments.cnpjCpf != null &&
                              _arguments.cnpjCpf.replaceAll(" ", "") != "")
                            Container(
                              padding:
                                  EdgeInsets.only(top: 65, left: 69, right: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _arguments.cnpjCpf,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          //if(arguments.cnpjCpf != null && arguments.cnpjCpf.replaceAll(" ", "") != "")
                          Container(
                            padding:
                                EdgeInsets.only(top: 130, left: 69, right: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Hino desde: 03/02/2020',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))),
              if (loaded != null)
                SliverFillRemaining(
                  child: ListView(
                    padding: EdgeInsets.only(top: 5),
                    children: loaded,
                  ),
                ),
            ]),
            floatingActionButton: _bottomButtons(),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedIconTheme:
                  IconThemeData(color: ThemeApp.Theme.primaryContrast),
              unselectedIconTheme: IconThemeData(
                  color: ThemeApp.Theme.primaryContrast.withOpacity(0.72)),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.mapMarkedAlt),
                  title: Text('Endereço'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.eye),
                  title: Text('Visualizar'),
                ),
              ],
              backgroundColor: Theme.of(context).primaryColor,
              currentIndex: _selectedIndex,
              selectedItemColor: ThemeApp.Theme.primaryContrast,
              onTap: _onItemTapped,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _bottomButtons() {
    return _renderSpeedDial();
  }

  SpeedDial _renderSpeedDial() {
    List<SpeedDialChild> children = [
      if (_podeEditar)
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.pencilAlt, color: Colors.grey[600]),
          onTap: () => Navigator.pushNamed(
            context,
            '/hinos/cadastrar',
            arguments: <String, dynamic>{
              "hino": _arguments,
              "endereco": _arguments.enderecos.isEmpty
                  ? null
                  : _arguments.enderecos.first
            },
          ).then(
            (value) => setState(
              () {
                _future = _build(_arguments.idLocal);
              },
            ),
          ),
          backgroundColor: Colors.white,
        ),
      if (_arguments.id == null)
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
      Navigator.of(context).pop();
      await _hinosService.delete(_hino.id);
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
