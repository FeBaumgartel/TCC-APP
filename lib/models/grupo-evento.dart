

import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/models/grupo.dart';

class GrupoEvento {
  int? id;
  int? idGrupo;
  Grupo? grupo;
  int? idEvento;
  Evento? evento;
  String nome = '';

  GrupoEvento({
    this.id,
    this.idGrupo,
    this.idEvento
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'id_grupo': idGrupo,
      'id_evento': idEvento,
    };
  }

  GrupoEvento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idGrupo = map['id_grupo'];
    idEvento = map['id_evento'];
  }


  GrupoEvento.fromJsonChip(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }
}