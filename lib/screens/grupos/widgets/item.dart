import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/models/grupo.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;

// ignore: must_be_immutable
class Item extends StatelessWidget {
  Grupo _grupo;
  Function _redirectCallBack;

  Item(this._grupo, this._redirectCallBack){

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        margin: EdgeInsets.fromLTRB(16.0, 5, 16.0, 5),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, '/grupos/visualizar',
                    arguments: _grupo)
                .then((value) => _redirectCallBack());
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 10, 8),
                            child: Text(
                              _grupo.nome,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]
                ),
              if (_grupo.descricao != null &&
                  _grupo.descricao.replaceAll(" ", "") != "")
                _renderLinhaDados(_grupo.descricao),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderLinhaDados(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 5.0),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                texto,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
