
class Hino {
  int id;
  String nome;
  String letra;

  Hino({
    this.id,
    this.nome,
    this.letra
  });
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'letra': letra
    };
  }


  Hino.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    letra = map['letra'];
  }
}