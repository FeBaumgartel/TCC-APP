import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/models/grupo.dart';

class UsuarioGrupo {
  int id;
  int idGrupo;
  Grupo grupo;
  int idEvento;
  Evento evento;


  UsuarioGrupo({
    this.id,
    this.idGrupo,
    this.idEvento
  });
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'id_grupo': idGrupo,
      'id_evento': idEvento
    };
  }


  UsuarioGrupo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idGrupo = map['id_grupo'];
    idEvento = map['id_evento'];
  }
}