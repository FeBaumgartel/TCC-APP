import 'dart:async';

import 'package:tcc_app/models/grupo.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/repositorio.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/evento-database.dart';
import 'package:sqflite/sql.dart';
import 'package:tcc_app/services/database.dart' as data;
import 'package:sqflite/sqlite_api.dart';

class GruposService extends RepositorioSimples {
  final data.Database _database = data.Database.create();
  final String _tabela = 'grupos';

  @override
  String get tabela => _tabela;
  @override
  data.Database get database => _database;

  Future<Grupo> insert(Grupo grupo) async {

    grupo.id = await _database.db.insert(_tabela, grupo.toMap());

    return grupo;
  }

  Future<void> excluirGrupos(id, bool excluirTodos, bool forceDelete) async {
    String queryDelete = 'DELETE FROM grupos WHERE ';
    String where = 'id = ?';
    String query = queryDelete + where;

    await _database.db.rawQuery(query, [id]);
  }
  
  Future<Grupo> updateGrupos(
    Grupo grupo) async {

    grupo.id = await _database.db.update(_tabela, grupo.toMap(),
        where: 'id = ?', whereArgs: [grupo.id]);

    return grupo;
  }

  Future<List<Grupo>> getGrupos({
    int pagina = 1,
    int porPagina = 10
  }) async {
    List<Map> maps = await _database.db.query(
      _tabela,
      orderBy: 'id DESC',
      limit: porPagina,
      offset: (porPagina * (pagina - 1)),
    );

    if (maps.length == 0) {
      return new List<Grupo>();
    }

    List<Grupo> grupos = new List<Grupo>();

    for (dynamic p in maps) {
      Grupo grupo = Grupo.fromMap(p);
      grupos.add(grupo);
    }

    return grupos;
  }

  Future<List<Grupo>> getGruposAll() async {
    List<Map> maps = await _database.db.query(_tabela);

    if (maps.length == 0) {
      return new List<Grupo>();
    }

    List<Grupo> grupos = new List<Grupo>();

    maps.forEach((p) {
      grupos.add(Grupo.fromMap(p));
    });

    return grupos;
  }

  Future<Grupo> getGrupo(int id) async {
    String sql =
      '''
        SELECT id, nome, descricao
        FROM grupos
        WHERE id = ?
      ''';
    List<Map> maps = await _database.db.rawQuery(sql, [id]);
    if (maps.length > 0) {
      Grupo event = (Grupo.fromMap(maps.first as Map<String, dynamic>));

      return event;
    } else {
      return null;
    }
  }

  Future<bool> checkSincronizacao(Grupo grupo) async {
    List<Map> maps = await _database.db
        .query(_tabela, where: 'id = ?', whereArgs: [grupo.id]);

    if (maps.length > 0) {
      return true;
    }

    return false;
  }

  Future<List<dynamic>> insertSincronizacao(
      List<Grupo> grupos) async {
    return await _database.db.transaction((txn) async {
      var batch = txn.batch();
      grupos.forEach((Grupo grupo) async {
        batch.insert(_tabela, grupo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });

      return await batch.commit();
    });
  }

  Future<int> getId(int idServidor) async {
    List<Map> result = await _database.db.query(_tabela,
        columns: ['id'], where: 'id = ?', whereArgs: [idServidor]);

    return result.first['id'];
  }

  Future<void> delete(int id) async {
    Batch batch = _database.db.batch();

    batch.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    await batch.commit();
  }

  @override
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase grupo) async {
    Set<String> campos = Grupo().toMap().keys.toSet();

    Map<String, dynamic> newObj = {...grupo.dados};

    grupo.dados.keys.forEach((key) {
      if (!campos.contains(key)) {
        newObj.remove(key);
      }
    });

    newObj['id'] = grupo.idRegistro;

    return newObj;
  }
}
