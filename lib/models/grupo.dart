import 'package:tcc_app/models/usuario.dart';

enum RelacionamentosGrupo { contas, usuarios }

class Grupo {
  int? id;
  String? nome;
  List<Usuario>? usuarios;

  Grupo({
    this.id,
    this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  Grupo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }
}