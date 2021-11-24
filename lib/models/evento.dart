
import 'package:tcc_app/models/grupo.dart';
import 'package:tcc_app/services/dao/grupos.dart';
class Evento {
  int id;
  String nome;
  String dataInicio;
  String dataFim;
  String data;
  int idGrupo;
  Grupo grupo;

  Evento({
    this.id,
    this.nome,
    this.dataInicio,
    this.dataFim,
    this.data,
    this.idGrupo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'id_grupo': idGrupo,
    };
  }

  Evento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    dataInicio = map['data_inicio'];
    dataFim = map['data_fim'];
    data = map['data'];
    idGrupo = map['id_grupo'];

    carregaGrupo();
  }

  Future<void> carregaGrupo() async {
    var grupos = new GruposService();
    this.grupo = await grupos.getGrupo(this.idGrupo);
  }
}