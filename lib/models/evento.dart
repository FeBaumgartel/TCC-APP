
class Evento {
  int id;
  String nome;
  String dataInicio;
  String dataFinal;
  String data;

  Evento({
    this.id,
    this.nome,
    this.dataInicio,
    this.dataFinal,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'data_inicio': dataInicio,
      'data_final': dataFinal,
      'data': data,
    };
  }

  Evento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    dataInicio = map['data_inicio'];
    dataFinal = map['data_final'];
    data = map['data'];
  }
}