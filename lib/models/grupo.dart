import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;
import 'package:tcc_app/models/usuario.dart';

enum RelacionamentosGrupo { contas, usuarios }

class Grupo {
  int id;
  String nome;
  String descricao;
  List<Usuario> usuarios;
  Color color;

  Grupo({
    this.id,
    this.nome,
    this.descricao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  Grupo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    descricao = map['descricao'];
    
    Random random = new Random();
    int randomNumber = random.nextInt(3);

    color = setColor(randomNumber);
  }
  
  setColor(int tipo) {
    if (tipo == 0) {
      return ThemeApp.Theme.primary;
    } else if (tipo == 1) {
      return ThemeApp.Theme.secondary;
    } else if (tipo == 2) {
      return ThemeApp.Theme.tertiary;
    }
  }
}