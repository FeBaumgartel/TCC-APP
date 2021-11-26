import 'package:tcc_app/models/usuario.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tcc_app/services/database.dart' as data;

class UsuariosService {
  final data.Database _database = data.Database.create();
  final String _tabela = 'usuarios';

  Future<Usuario> insert(Usuario usuario) async {
    usuario.id = await _database.db.insert(_tabela, usuario.toMap());
    return usuario;
  }

  Future<Usuario> getUsuario(int id) async {
    List<Map<String, dynamic>> maps = <Map<String, dynamic>>[];
    if (id != null)
      maps = await _database.db.query(
        _tabela,
        where: 'id = ?',
        whereArgs: [id],
      );

    if (maps.length > 0) {
      var usuario = Usuario.fromMap(maps.first);

      return usuario;
    }

    return new Usuario();
  }

  Future<int> delete(int id) async {
    return await _database.db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Usuario usuario) async {
    return await _database.db.update(
      _tabela,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<Usuario> insertOrUpdate(Usuario usuario) async {
    usuario.id = await _database.db.insert(_tabela, usuario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return usuario;
  }

  Future<Usuario> validarLogin(String email, String senha) async {
    List<Map<String, dynamic>> maps = await _database.db.query(
      _tabela,
      where: 'email = ? and senha = ?',
      whereArgs: [email, senha],
      orderBy: 'id DESC',
    );
    if (maps.length == 0) return null;
    Usuario usuario = new Usuario();

    usuario = Usuario.fromMap(maps.first);

    return usuario;
  }
}
