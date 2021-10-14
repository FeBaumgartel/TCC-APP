import 'package:flutter/material.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/services/sessao.dart';

class SessaoProvider extends ChangeNotifier {
  Usuario _usuario;

  SessaoProvider() {
    
  }

  Usuario get usuario => _usuario;

  set usuario(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }
}
