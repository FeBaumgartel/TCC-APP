import 'package:tcc_app/models/usuario.dart';

enum RelacionamentosGrupo { contas, usuarios }

class Grupo {
  int id;
  String nome;
  String descricao;
  List<Usuario> usuarios;

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
  }
}