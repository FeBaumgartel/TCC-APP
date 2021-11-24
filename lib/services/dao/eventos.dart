import 'dart:async';

import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/repositorio.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/evento-database.dart';
import 'package:sqflite/sql.dart';
import 'package:tcc_app/helpers/string-helper.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/services/database.dart' as data;
import 'package:sqflite/sqlite_api.dart';

class EventosService extends RepositorioSimples {
  final data.Database _database = data.Database.create();
  final String _tabela = 'eventos';

  @override
  String get tabela => _tabela;
  @override
  data.Database get database => _database;

  Future<Evento> insert(Evento evento) async {

    evento.id = await _database.db.insert(_tabela, evento.toMap());

    return evento;
  }

  Future<void> excluirEventos(id, bool excluirTodos, bool forceDelete) async {
    String queryDelete = 'DELETE FROM eventos WHERE ';
    String where = 'id = ?';
    String query = queryDelete + where;

    await _database.db.rawQuery(query, [id]);
  }
  
  Future<Evento> updateEventos(
    Evento evento) async {

    evento.id = await _database.db.update(_tabela, evento.toMap(),
        where: 'id = ?', whereArgs: [evento.id]);

    return evento;
  }

  Future<List<Evento>> getEventsDate(String date) async {
    String sql =
      '''
        SELECT id, id_grupo, nome, strftime(\'%Y-%m-%d\', data_inicio) as data, data_fim, data_inicio
        FROM eventos
        WHERE data = ?
      ''';                 
    List<Map> maps = await _database.db.rawQuery(sql, [date]);

    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });

    return eventos;
  }

  Future<List<Evento>> getEventsAll() async {
    List<Map> maps = await _database.db.query(_tabela);
    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });
    return eventos;
  }

  Future<List<Evento>> getDateMinMax() async {
    String sql =
        'SELECT MIN(data_inicio) as data_inicio , MAX(data_fim) as data_fim FROM eventos';
    List<Map> maps = await _database.db.rawQuery(sql, []);

    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });
    return eventos;
  }

  Future<List<Evento>> getEventsMonth(
      String month) async {
    String sql =
        '''
        SELECT id, id_grupo, nome, strftime('%m/%Y', data_inicio) as mes, strftime('%Y-%m-%d', data_inicio) as data, data_fim, data_inicio
        FROM eventos 
        WHERE mes = ?
        ''';
    List<Map> maps = await _database.db.rawQuery(sql, [month]);

    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });
    return eventos;
  }

  Future<List<Evento>> getEventsWeek(List<DateTime> week) async {
    List<String> weeks = [];

   for (int i=0; i < week.length;i++){
     var temp = week[i].toString().split(' ')[0];
     weeks.add('''
      '$temp'
     ''');
   }
    String sql =
      '''
      SELECT id, id_grupo, nome, strftime('%Y-%m-%d', data_inicio) as data, data_fim, data_inicio
      FROM eventos
      WHERE data IN (${weeks.join(',')})
    ''';
    List<Map> maps = await _database.db.rawQuery(sql, []);

    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });
    return eventos;
  }

  Future<Evento> getEvento(int id) async {
    String sql =
      '''
        SELECT id, id_grupo, nome, strftime('%m/%Y', data_inicio) as mes, strftime('%Y-%m-%d', data_inicio) as data, data_fim, data_inicio
        FROM eventos
        WHERE id = ?
      ''';
    List<Map> maps = await _database.db.rawQuery(sql, [id]);
    if (maps.length > 0) {
      Evento event = (Evento.fromMap(maps.first as Map<String, dynamic>));

      return event;
    } else {
      return null;
    }
  }

  Future<bool> checkSincronizacao(Evento evento) async {
    List<Map> maps = await _database.db
        .query(_tabela, where: 'id = ?', whereArgs: [evento.id]);

    if (maps.length > 0) {
      return true;
    }

    return false;
  }

  Future<List<dynamic>> insertSincronizacao(
      List<Evento> eventos) async {
    return await _database.db.transaction((txn) async {
      var batch = txn.batch();
      eventos.forEach((Evento evento) async {
        batch.insert(_tabela, evento.toMap(),
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
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase evento) async {
    Set<String> campos = Evento().toMap().keys.toSet();

    Map<String, dynamic> newObj = {...evento.dados};

    evento.dados.keys.forEach((key) {
      if (!campos.contains(key)) {
        newObj.remove(key);
      }
    });

    newObj['id'] = evento.idRegistro;

    return newObj;
  }
}
