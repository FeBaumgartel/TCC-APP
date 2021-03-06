abstract class Sql {
  static List<String> sqls = [
    "CREATE TABLE igrejas (id INTEGER PRIMARY KEY AUTOINCREMENT, nome varchar(250) NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL)",
    "CREATE TABLE grupos (id INTEGER PRIMARY KEY AUTOINCREMENT, id_igreja INTEGER UNSIGNED , nome varchar(250) NOT NULL, descricao text, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_igreja) REFERENCES igrejas (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE eventos (id INTEGER PRIMARY KEY AUTOINCREMENT, id_grupo INTEGER UNSIGNED, nome varchar(250) NOT NULL, data_inicio datetime DEFAULT NULL, data_fim datetime DEFAULT NULL, id_igreja INTEGER UNSIGNED, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_igreja) REFERENCES igrejas (id) ON DELETE NO ACTION)",
    "CREATE TABLE hinos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome varchar(250) NOT NULL, letra text NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL)",
    "CREATE TABLE hinos_eventos (id INTEGER PRIMARY KEY AUTOINCREMENT, sequencia int(11) NOT NULL, id_hino INTEGER UNSIGNED , id_evento INTEGER UNSIGNED , created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_evento) REFERENCES eventos (id) ON DELETE NO ACTION ON UPDATE NO ACTION, FOREIGN KEY (id_hino) REFERENCES hinos (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE igrejas_usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, id_usuario INTEGER UNSIGNED , id_igreja INTEGER UNSIGNED , created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_igreja) REFERENCES igrejas (id) ON DELETE NO ACTION ON UPDATE NO ACTION, FOREIGN KEY (id_usuario) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, id_grupo INTEGER UNSIGNED, nome varchar(250) NOT NULL, email varchar(250) NOT NULL, senha varchar(250) NOT NULL, tipo int(11) NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL)",

    "INSERT INTO grupos (id, nome, descricao) VALUES (1, 'JERC', 'Grupo de jovens')",
    "INSERT INTO usuarios (id, id_grupo, nome, email, senha, tipo) VALUES (1,1, 'felipe', 'admin', 'admin', 1)" ,
    "INSERT INTO usuarios (id, id_grupo, nome, email, senha, tipo) VALUES (2,1, 'felipinho', 'user', 'user', 2)" 
    ];
}
