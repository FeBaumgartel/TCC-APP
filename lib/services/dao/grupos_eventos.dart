import 'package:tcc_app/models/grupo-evento.dart';
import 'package:tcc_app/services/database.dart' as data;
import 'package:tcc_app/services/sincronizacao/atualizacao/repositorio.dart';
import 'package:tcc_app/services/sincronizacao/atualizacao/evento-database.dart';

class GruposEventosService extends RepositorioSimples {
  final data.Database _database = data.Database.create();
  final String _tabela = 'usuarios';

  @override
  String get tabela => _tabela;
  @override
  data.Database get database => _database;

  Future<void> downloadFotosUsuarios() async {
    List<Map> result = await _database.db
        .query(_tabela, where: 'imagem_local IS NULL AND imagem IS NOT NULL');

    List<GrupoEvento> fotos = [];

    if (result.length == 0) {
      return;
    }

    fotos.addAll(result.map((e) => GrupoEvento.fromJsonChip(e as Map<String, dynamic>)));
  }

  Future<void> update(GrupoEvento foto) async {
    _database.db.update(
      _tabela,
      foto.toMap(),
      where: 'id = ?',
      whereArgs: [foto.id],
    );
  }

  @override
  Future<Map<String, dynamic>> toMapSincronizacao(EventoDatabase evento) async {
    Set<String> campos = {
      'id',
      'nome',
      'imagem',
      'nivel',
      'imagem_local',
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
}
