import 'package:flutter/foundation.dart';

enum RelacionamentosUsuario { grupo }

class Usuario {
  int id;
  String nome;
  String email;
  String senha;
  int tipo;
  int idGrupo;

  Usuario({
    this.id,
    this.nome,
    this.email,
    this.tipo,
    this.idGrupo,
    this.senha,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
      'id_grupo': idGrupo,
    };
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
    senha = map['senha'];
    tipo = map['tipo'];
    idGrupo = map['id_grupo'];
  }

  // função pra autenticação e sessão do usuário
  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    tipo = json['tipo'];
    idGrupo = json['id_grupo'];
  }

  // função pra autenticação e sessão do usuário
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
      'id_grupo': idGrupo,
    };
  }
}
