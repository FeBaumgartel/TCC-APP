import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/screens/hinos/widgets/item.dart' as Item;
import 'package:tcc_app/screens/hinos/widgets/skeletons/hino-item.dart';
import 'package:tcc_app/services/dao/hinos.dart';
import 'package:tcc_app/models/hino.dart';
import 'package:rxdart/rxdart.dart';

class Hinos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new HinosPage();
  }
}

class HinosPage extends StatefulWidget {
  HinosPage({Key key}) : super(key: key);

  @override
  _HinosPageState createState() => _HinosPageState();
}

class _HinosPageState extends State<HinosPage> {
  final HinosService _hinosService = new HinosService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription _subscription;

  List<Widget> _widgets = List<Widget>();
  List<Hino> _hinos = List<Hino>();
  final _scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  bool _loading = false;
  Future<List<Widget>> _future;
  int _pagina = 1;

  _HinosPageState() {
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

  Future<List<Hino>> _getHinos() async {
    if (this._pagina == 1) this._hinos = List<Hino>();
    List<Hino> hinos;

    hinos = await this._hinosService.getHinos(pagina: _pagina);
debugPrint('movieTitle: $hinos');

    if (hinos.length > 0) {
      if (hinos.length < 10) {
        this.setState(() => this._loading = false);
      } else {
        this.setState(() => this._loading = true);
      }
    } else {
      this.setState(() => this._loading = false);
    }

    this._hinos.addAll(hinos);

    return this._hinos;
  }

  Future<List<Widget>> _build() async {
    this._widgets = new List<Widget>();
    List<Hino> hinos;
    hinos = await this._getHinos();

    hinos.forEach((Hino hino) {
      this._widgets.add(
            Item.Item(
              hino,
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
      appBar: AppBar(title: Text('Hinos')),
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
                          'Nenhum hino aqui!',
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
                  return HinoItem();
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
              child: Icon(FontAwesomeIcons.plus),
              onPressed: () {
                Navigator.of(context).pushNamed('/hinos/cadastrar',
                    arguments: <String, dynamic>{
                      "hino": null
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
