
enum RelacionamentosUsuario { grupo }

class Usuario {
  int id;
  String nome;
  String email;
  String senha;
  int id_grupo;

  Usuario({
    this.id,
    this.nome,
    this.email,
    this.senha,
    this.id_grupo,
  });
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'id_grupo': id_grupo,
    };
  }


  Usuario.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
    senha = map['senha'];
    id_grupo = map['id_grupo'];
  }

  // função pra autenticação e sessão do usuário
  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    id_grupo = json['id_grupo'];
  }

  // função pra autenticação e sessão do usuário
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'id_grupo': id_grupo,
    };
  }
}