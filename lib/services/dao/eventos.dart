import 'dart:async';

import 'package:tcc_app/models/grupo-evento.dart';
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
    String queryUpdate =
        'UPDATE eventos SET deleted_at = CURRENT_TIMESTAMP, sinc_status = 0 WHERE ';
    String where =
        (excluirTodos == true) ? 'codigo_recorrencia = ?' : 'id = ?';
    String query = ((forceDelete == true) ? queryDelete : queryUpdate) + where;

    if (forceDelete == true) {
      await _database.db.rawQuery(
          'DELETE FROM evento_envolvidos WHERE id_evento IN (SELECT id FROM eventos WHERE ' +
              where +
              ')',
          [id]);
    } else {
      await _database.db.rawQuery(
          'UPDATE evento_envolvidos SET deleted_at = CURRENT_TIMESTAMP WHERE id_evento IN (SELECT id FROM eventos WHERE ' +
              where +
              ')',
          [id]);
    }

    await _database.db.rawQuery(query, [id]);
  }

  Future<Evento> updateEventos(
    Evento evento) async {

    evento.id = await _database.db.update(_tabela, evento.toMap(),
        where: 'id = ?', whereArgs: [evento.id]);

    return evento;
  }

  Future<List<Evento>> getEventsDate(String date, List<int> filtrosTipos,
      List<int> filtrosUsers, String? pesquisa) async {
    String sql =
      '''
        SELECT eventos.id, eventos.id, id_cliente, observacao_inicial, observacao_final, eventos.tipo, eventos.localizacao, titulo, strftime(\'%Y-%m-%d\', data_inicio) as data, data_fim, data_inicio, envolvidos,recorrente, codigo_recorrencia, tipo_recorrencia, quantidade_recorrencia, data_fim_recorrencia, tipo_visita, tipo_lembrete, clientes.nome_fantasia as cli_nome_fantasia
        FROM eventos LEFT JOIN clientes ON clientes.id = eventos.id_cliente
        WHERE data = ?
      ''';
    if (filtrosTipos.isNotEmpty) {
      sql += 'AND eventos.tipo IN (${filtrosTipos.join(',')})';
    }
    if (filtrosUsers.isNotEmpty) {
      sql +=
          'AND eventos.id IN (SELECT id_evento FROM evento_envolvidos WHERE id_usuario IN (${filtrosUsers.join(',')}))';
    }
    if(pesquisa != ''){
      sql += '''
      AND (eventos.titulo LIKE '%$pesquisa%' 
      OR eventos.localizacao LIKE '%$pesquisa%' 
      OR eventos.observacao_inicial LIKE '%$pesquisa%' 
      OR eventos.observacao_final LIKE '%$pesquisa%' 
      OR eventos.envolvidos LIKE '%$pesquisa%' 
      OR clientes.nome_fantasia LIKE '%$pesquisa%' 
      OR eventos.id IN (SELECT id_evento FROM evento_envolvidos WHERE id_usuario IN (SELECT id FROM usuarios WHERE nome LIKE '%$pesquisa%' ))
      OR eventos.id IN (SELECT id_evento FROM evento_envolvidos WHERE id_representada_contato IN (SELECT id FROM representadas_contatos WHERE nome LIKE '%$pesquisa%' ))
      OR eventos.id IN (SELECT id_evento FROM evento_envolvidos WHERE id_cliente_contato IN (SELECT id FROM clientes_contatos WHERE nome LIKE '%$pesquisa%' ))
      )
      ''';
    }                        
    sql += ' AND eventos.deleted_at IS NULL';
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
      String month, List<int> filtrosTipos, List<int> filtrosUsers) async {
    String sql =
        '''
        SELECT eventos.id, eventos.id, id_cliente, observacao_inicial, observacao_final, eventos.tipo, eventos.localizacao, titulo, strftime('%m/%Y', data_inicio) as mes, strftime('%Y-%m-%d', data_inicio) as data, data_fim, data_inicio, envolvidos, recorrente, codigo_recorrencia, tipo_recorrencia, quantidade_recorrencia, data_fim_recorrencia, tipo_visita, tipo_lembrete, clientes.nome_fantasia as cli_nome_fantasia
        FROM eventos
        LEFT JOIN clientes ON clientes.id = eventos.id_cliente
        WHERE mes = ?
        ''';

    if (filtrosTipos.isNotEmpty) {
      sql += 'AND eventos.tipo IN (${filtrosTipos.join(',')}) ';
    }
    if (filtrosUsers.isNotEmpty) {
      sql +=
          'AND eventos.id IN (SELECT id_evento FROM evento_envolvidos WHERE id_usuario IN (${filtrosUsers.join(',')})) ';
    }
    sql += 'AND eventos.deleted_at IS NULL';
    List<Map> maps = await _database.db.rawQuery(sql, [month]);

    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });
    return eventos;
  }

  Future<List<Evento>> getEventsWeek(List<DateTime> week,
      List<int> filtrosTipos, List<int> filtrosUsers) async {
    List<String> weeks = [];

   for (int i=0; i < week.length;i++){
     var temp = week[i].toString().split(' ')[0];
     weeks.add('''
      '$temp'
     ''');
   }
    String sql =
      '''
      SELECT eventos.id, eventos.id, id_cliente, observacao_inicial, observacao_final, eventos.tipo, eventos.localizacao, titulo, strftime('%Y-%m-%d', data_inicio) as data, data_fim, data_inicio, envolvidos, recorrente, codigo_recorrencia, tipo_recorrencia, quantidade_recorrencia, data_fim_recorrencia, tipo_visita, tipo_lembrete, clientes.nome_fantasia as cli_nome_fantasia
      FROM eventos LEFT JOIN clientes ON clientes.id = eventos.id_cliente
      WHERE data IN (${weeks.join(',')})
    ''';

    if (filtrosTipos.isNotEmpty) {
      sql += 'AND eventos.tipo IN (${filtrosTipos.join(',')}) ';
    }
    if (filtrosUsers.isNotEmpty) {
      sql +=
          'AND eventos.id IN (SELECT id_evento FROM evento_envolvidos WHERE id_usuario IN (${filtrosUsers.join(',')})) ';
    }
    sql += 'AND eventos.deleted_at IS NULL';
    List<Map> maps = await _database.db.rawQuery(sql, []);

    List<Evento> eventos = [];

    maps.forEach((element) {
      eventos.add(Evento.fromMap(element as Map<String, dynamic>));
    });
    return eventos;
  }

  Future<Evento?> getEvento(int id) async {
    String sql =
      '''
        SELECT eventos.id, eventos.id, id_cliente, id_usuario, observacao_inicial, observacao_final, eventos.tipo, eventos.localizacao, titulo, strftime('%m/%Y', data_inicio) as mes, strftime('%Y-%m-%d', data_inicio) as data, data_fim, data_inicio, envolvidos, recorrente, codigo_recorrencia, tipo_recorrencia, quantidade_recorrencia, data_fim_recorrencia, tipo_visita, tipo_lembrete, clientes.nome_fantasia as cli_nome_fantasia
        FROM eventos
        LEFT JOIN clientes ON clientes.id = eventos.id_cliente
        WHERE eventos.id = ?
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

    Map<String, dynamic> newObj = {...evento.dados!};

    evento.dados!.keys.forEach((key) {
      if (!campos.contains(key)) {
        newObj.remove(key);
      }
    });

    newObj['id'] = evento.idRegistro;

    return newObj;
  }
}
