

import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/models/hino.dart';

class HinoEvento {
  int? id;
  int? sequencia;
  int? idHino;
  Hino? hino;
  int? idEvento;
  Evento? evento;

  HinoEvento({
    this.id,
    this.sequencia,
    this.idHino,
    this.idEvento
  });
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sequencia': sequencia,
      'id_hino': idHino,
      'id_evento': idEvento
    };
  }


  HinoEvento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    sequencia = map['sequencia'];
    idHino = map['id_hino'];
    idEvento = map['id_evento'];
  }
}