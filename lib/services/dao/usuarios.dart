import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/services/database.dart' as data;
import 'package:tcc_app/services/sincronizacao/atualizacao/repositorio.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/evento-database.dart';
import 'package:sqflite/sql.dart';

class UsuariosService extends RepositorioSimples {
  final data.Database _database = data.Database.create();
  final String _tabela = 'usuarios';

  @override
  String get tabela => _tabela;
  @override
  data.Database get database => _database;

  Future<List<dynamic>> insertSincronizacao(List<Usuario> users) async {
    return await _database.db.transaction((txn) async {
      var batch = txn.batch();
      users.forEach((user) async {
        batch.insert(
          _tabela,
          user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      return await batch.commit();
    });
  }

  Future<List<Usuario>> getUsuarios() async {
    String sql =
        'SELECT id, nome, imagem, imagem_local FROM usuarios ORDER BY nome';
    List<Map> maps = await _database.db.rawQuery(sql, []);

    List<Usuario> usuarios = [];

    maps.forEach((element) {
      Usuario usuario = Usuario.fromMap(element as Map<String, dynamic>);
      usuarios.add(usuario);
    });
    return usuarios;
  }

  Future<Usuario> getUsuarioById(int id) async {
    List<Map> maps = await _database.db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      var usuario = Usuario.fromMap(maps.first as Map<String, dynamic>);
      return usuario;
    }

    return null;
  }

  Future<void> update(Usuario usuario) async {
    _database.db.update(
      _tabela,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  @override
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase evento) async {
    Set<String> campos = {
      'id',
      'nome',
      'imagem',
      'nivel',
      'id_grupo_permissao',
    };

    Map<String, dynamic> newObj = {...evento.dados};

    evento.dados.keys.forEach((key) {
      if (!campos.contains(key)) {
        newObj.remove(key);
      }
    });

    if (newObj.containsKey('imagem')) {
      newObj['imagem_local'] = null;
    }

    newObj['id'] = evento.idRegistro;

    return newObj;
  }

  Future<List<Usuario>> getPendentesDownload() async {
    List<Map> result = await _database.db
        .query(_tabela, where: 'imagem_local IS NULL AND imagem IS NOT NULL');

    return result.map((e) => Usuario.fromMap(e as Map<String, dynamic>)).toList();
  }
}
