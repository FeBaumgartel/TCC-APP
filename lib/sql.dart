abstract class Sql {
  static List<String> sqls = <String>[
    
    "CREATE TABLE igrejas (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, nome varchar(250) NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL)",
    "CREATE TABLE eventos (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, nome varchar(250) NOT NULL, data datetime NOT NULL, data_inicio date DEFAULT NULL, data_fim date DEFAULT NULL, id_igreja INTEGER UNSIGNED NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_igreja) REFERENCES igrejas (id) ON DELETE NO ACTION)",
    "CREATE TABLE grupos (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, id_igreja INTEGER UNSIGNED NOT NULL, nome varchar(250) NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_igreja) REFERENCES igrejas (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE grupos_eventos (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, id_grupo INTEGER UNSIGNED NOT NULL, id_evento INTEGER UNSIGNED NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_evento) REFERENCES eventos (id) ON DELETE NO ACTION ON UPDATE NO ACTION, FOREIGN KEY (id_grupo) REFERENCES grupos (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE hinos (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, nome varchar(250) NOT NULL, letra text NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL)",
    "CREATE TABLE hinos_eventos (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, sequencia int(11) NOT NULL, id_hino INTEGER UNSIGNED NOT NULL, id_evento INTEGER UNSIGNED NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_evento) REFERENCES eventos (id) ON DELETE NO ACTION ON UPDATE NO ACTION, FOREIGN KEY (id_hino) REFERENCES hinos (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE igrejas_usuarios (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, id_usuario INTEGER UNSIGNED NOT NULL, id_igreja INTEGER UNSIGNED NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_igreja) REFERENCES igrejas (id) ON DELETE NO ACTION ON UPDATE NO ACTION, FOREIGN KEY (id_usuario) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
    "CREATE TABLE usuarios (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, nome varchar(250) NOT NULL, email varchar(250) NOT NULL, senha varchar(250) NOT NULL, tipo int(11) NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL)",
    "CREATE TABLE usuarios_grupos (id INTEGER UNSIGNED PRIMARY KEY NOT NULL, id_usuario INTEGER UNSIGNED NOT NULL, id_grupo INTEGER UNSIGNED NOT NULL, created_at timestamp NULL DEFAULT NULL, updated_at timestamp NULL DEFAULT NULL, FOREIGN KEY (id_grupo) REFERENCES grupos (id) ON DELETE NO ACTION ON UPDATE NO ACTION, FOREIGN KEY (id_usuario) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",

    "INSERT INTO usuarios (id, nome, email, senha, tipo) VALUES (1, 'felipe', 'admin', 'admin', 1)" 
    ];
}
