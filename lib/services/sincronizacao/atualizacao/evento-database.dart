class EventoDatabase {
  String tabela;
  String acao;
  int idRegistro;
  Map<String, dynamic> dados;

  EventoDatabase({
    this.tabela,
    this.acao,
    this.idRegistro,
    this.dados,
  });

  Map<String, dynamic> toMap() {
    return {
      'tabela': tabela,
      'acao': acao,
      'id_registro': idRegistro,
      'dados': dados,
    };
  }

  static EventoDatabase fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EventoDatabase(
      tabela: map['tabela'],
      acao: map['acao'],
      idRegistro: map['id_registro'],
      dados: map['dados'],
    );
  }
}