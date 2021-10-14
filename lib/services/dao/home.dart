import 'package:tcc_app/services/database.dart';

class HomeService {
  final Database _database = Database.create();
  String hoje = DateTime.now().toString().split(" ")[0];

  Future<int> getAtividades() async{

    int atividades = 0;
    String sql = 'SELECT COUNT(1) as total, strftime(\'%Y-%m-%d\', data_inicio) as data FROM eventos WHERE data = ?';
    List<Map> maps = await _database.db.rawQuery(sql, [hoje]);

    if(maps.length > 0){
      atividades = maps.first['total'];
    }

    return atividades;
  }

}