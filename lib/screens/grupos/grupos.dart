import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/screens/grupos/widgets/item.dart' as Item;
import 'package:tcc_app/screens/grupos/widgets/skeletons/grupo-item.dart';
import 'package:tcc_app/services/dao/grupos.dart';
import 'package:tcc_app/models/grupo.dart';
import 'package:rxdart/rxdart.dart';

class Grupos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GruposPage();
  }
}

class GruposPage extends StatefulWidget {
  GruposPage({Key key}) : super(key: key);

  @override
  _GruposPageState createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  final GruposService _gruposService = new GruposService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription _subscription;

  List<Widget> _widgets = List<Widget>();
  List<Grupo> _grupos = List<Grupo>();
  final _scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  bool _loading = false;
  Future<List<Widget>> _future;
  int _pagina = 1;

  _GruposPageState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        this.setState(() {
          this._pagina++;
          _future = _build();
        });
      }
    });
    _future = _build();
  }

  Future<List<Grupo>> _getGrupos() async {
    if (this._pagina == 1) this._grupos = List<Grupo>();
    List<Grupo> grupos;

    grupos = await this._gruposService.getGrupos(pagina: _pagina);

    if (grupos.length > 0) {
      if (grupos.length < 10) {
        this.setState(() => this._loading = false);
      } else {
        this.setState(() => this._loading = true);
      }
    } else {
      this.setState(() => this._loading = false);
    }

    this._grupos.addAll(grupos);

    return this._grupos;
  }

  Future<List<Widget>> _build() async {
    this._widgets = new List<Widget>();
    List<Grupo> grupos;
    grupos = await this._getGrupos();

    grupos.forEach((Grupo grupo) {
      this._widgets.add(
            Item.Item(
              grupo,
              () => setState(() {
                _future = _build();
              }),
            ),
          );
    });
    return this._widgets;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Grupos')),
      body: new FutureBuilder<List<Widget>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData) {
            List<Widget> loaded = snapshot.data;
            return Column(children: <Widget>[
              new Expanded(
                  child: ListView.builder(
                itemCount: (loaded.length + 1),
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index == loaded.length) {
                    if (this._loading) {
                      return Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                          )));
                    } else if (loaded.length > 0) {
                      return Container();
                    } else {
                      return Container(
                        child: Center(
                            child: Text(
                          'Nenhum grupo aqui!',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        )),
                        height: MediaQuery.of(context).size.height,
                      );
                    }
                  }
                  return loaded[index];
                },
              ))
            ]);
          } else {
            return ListView.builder(
                itemCount: 10,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GrupoItem();
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
              child: Icon(FontAwesomeIcons.plus),
              onPressed: () {
                Navigator.of(context).pushNamed('/grupos/cadastrar',
                    arguments: <String, dynamic>{
                      "grupo": null
                    }).then((value) => this.setState(() {
                      _scrollController.jumpTo(0);
                      _pagina = 1;
                      _widgets = List();
                      _future = _build();
                    }));
              },
            )
    );
  }
}
