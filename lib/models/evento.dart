
class Evento {
  int id;
  String nome;
  String dataInicio;
  String dataFim;
  String data;

  Evento({
    this.id,
    this.nome,
    this.dataInicio,
    this.dataFim,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
    };
  }

  Evento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    dataInicio = map['data_inicio'];
    dataFim = map['data_fim'];
    data = map['data'];
  }
}