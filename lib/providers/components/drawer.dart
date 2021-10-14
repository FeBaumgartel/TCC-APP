import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/services/sessao.dart';
import 'package:package_info/package_info.dart';

class DrawerProvider extends ChangeNotifier {
  final BuildContext context;
  StreamSubscription _streamSessao;
  DateTime _ultimaSincronizacao;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  ImageProvider imgUser;
  PackageInfo packageInfo;
  Usuario usuario;
  bool mostrarFalhas = false;

  DrawerProvider(this.context) {
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value;
      notifyListeners();
    });
  }

  DateTime get ultimaSincronizacao => _ultimaSincronizacao;

  String getNomeAvatar() {
    if (usuario.nome != null) {
      List nome = usuario.nome.split(' ');
      return (nome[0][0] + nome[nome.length - 1][0]);
    }

    return '';
  }

  @override
  void dispose() async {
    super.dispose();
    await _streamSessao.cancel();
  }
}
