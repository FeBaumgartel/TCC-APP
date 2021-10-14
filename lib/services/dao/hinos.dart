import 'dart:async';

import 'package:tcc_app/models/hino.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/repositorio.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/evento-database.dart';
import 'package:sqflite/sql.dart';
import 'package:tcc_app/helpers/string-helper.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/services/database.dart' as data;
import 'package:sqflite/sqlite_api.dart';

class HinosService extends RepositorioSimples {
  final data.Database _database = data.Database.create();
  final String _tabela = 'hinos';

  @override
  String get tabela => _tabela;
  @override
  data.Database get database => _database;

  Future<Hino> insert(Hino hino) async {

    hino.id = await _database.db.insert(_tabela, hino.toMap());

    return hino;
  }

  Future<void> excluirHinos(id, bool excluirTodos, bool forceDelete) async {
    String queryDelete = 'DELETE FROM hinos WHERE ';
    String where = 'id = ?';
    String query = queryDelete + where;

    await _database.db.rawQuery(query, [id]);
  }

  List<Hino> hinosDia(DateTime data) {


    return [];
  }
  
  Future<Hino> updateHinos(
    Hino hino) async {

    hino.id = await _database.db.update(_tabela, hino.toMap(),
        where: 'id = ?', whereArgs: [hino.id]);

    return hino;
  }

  Future<List<Hino>> getEventsAll() async {
    List<Map> maps = await _database.db.query(_tabela);
    List<Hino> hinos = [];

    maps.forEach((element) {
      hinos.add(Hino.fromMap(element as Map<String, dynamic>));
    });
    return hinos;
  }

  Future<Hino> getHino(int id) async {
    String sql =
      '''
        SELECT id, nome, letra
        FROM hinos
        WHERE id = ?
      ''';
    List<Map> maps = await _database.db.rawQuery(sql, [id]);
    if (maps.length > 0) {
      Hino event = (Hino.fromMap(maps.first as Map<String, dynamic>));

      return event;
    } else {
      return null;
    }
  }

  Future<bool> checkSincronizacao(Hino hino) async {
    List<Map> maps = await _database.db
        .query(_tabela, where: 'id = ?', whereArgs: [hino.id]);

    if (maps.length > 0) {
      return true;
    }

    return false;
  }

  Future<List<dynamic>> insertSincronizacao(
      List<Hino> hinos) async {
    return await _database.db.transaction((txn) async {
      var batch = txn.batch();
      hinos.forEach((Hino hino) async {
        batch.insert(_tabela, hino.toMap(),
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

  @override
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase hino) async {
    Set<String> campos = Hino().toMap().keys.toSet();

    Map<String, dynamic> newObj = {...hino.dados};

    hino.dados.keys.forEach((key) {
      if (!campos.contains(key)) {
        newObj.remove(key);
      }
    });

    newObj['id'] = hino.idRegistro;

    return newObj;
  }
}
