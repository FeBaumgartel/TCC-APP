import 'package:tcc_app/services/database.dart' as data;
import 'package:tcc_app/services/sincronizacao/atualizacao/evento-database.dart';
import 'package:sqflite/sql.dart';

abstract class Mapeavel {
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase ev);
}

abstract class RepositorioSincronizacao implements Mapeavel {
  String get tabela;
  data.Database get database;

  Future<void> insertSinc(Map<String, dynamic> obj);
  Future<void> updateSinc(Map<String, dynamic> obj);
  Future<void> deleteSinc(Map<String, dynamic> obj);
}

abstract class RepositorioSimples implements RepositorioSincronizacao {
  Future<void> insertSinc(Map<String, dynamic> obj) async {
    await beforeInsert(obj);
    var id = await database.db.insert(tabela, obj, conflictAlgorithm: ConflictAlgorithm.ignore);
    // tratamento para evitar ConflictAlgorithn.replace pois o registro perderia id_local
    if (id == null) {
      await database.db.update(tabela, obj, where: 'id = ?', whereArgs: [obj['id']]);
    }
    await afterInsert(obj);
  }

  Future<void> updateSinc(Map<String, dynamic> obj) async {
    if (obj.isEmpty) {
      return;
    }

    await beforeUpdate(obj);
    await database.db
        .update(tabela, obj, where: 'id = ?', whereArgs: [obj['id']]);
    await afterUpdate(obj);
  }

  Future<void> deleteSinc(Map<String, dynamic> obj) async {
    await beforeDelete(obj);
    await database.db.delete(tabela, where: 'id = ?', whereArgs: [obj['id']]);
    await afterDelete(obj);
  }

  Future<void> beforeInsert(Map<String, dynamic> obj) async {}

  Future<void> afterInsert(Map<String, dynamic> obj) async {}

  Future<void> beforeUpdate(Map<String, dynamic> obj) async {}

  Future<void> afterUpdate(Map<String, dynamic> obj) async {}

  Future<void> beforeDelete(Map<String, dynamic> obj) async {}

  Future<void> afterDelete(Map<String, dynamic> obj) async {}
}

abstract class RepositorioTabelaPivot implements RepositorioSincronizacao {
  
  @override
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase ev) async {
    return ev.dados;
  }

  Future<void> insertSinc(Map<String, dynamic> obj) async {
    await beforeInsert(obj);
    await database.db
        .insert(tabela, obj, conflictAlgorithm: ConflictAlgorithm.ignore);
    await afterInsert(obj);
  }

  Future<void> deleteSinc(Map<String, dynamic> obj) async {
    await beforeDelete(obj);
    var where = obj.keys.map((k) => '$k = ?').join(' AND ');
    var whereArgs = obj.values.toList();
    await database.db.delete(tabela, where: where, whereArgs: whereArgs);
    await afterDelete(obj);
  }

  Future<void> updateSinc(Map<String, dynamic> obj) async {}

  Future<void> beforeInsert(Map<String, dynamic> obj) async {}

  Future<void> afterInsert(Map<String, dynamic> obj) async {}

  Future<void> beforeDelete(Map<String, dynamic> obj) async {}

  Future<void> afterDelete(Map<String, dynamic> obj) async {}
}
