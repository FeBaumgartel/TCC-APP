import 'package:flutter/material.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/services/dao/home.dart';
import 'package:tcc_app/services/sessao.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;

class HomeProvider extends ChangeNotifier {
  BuildContext context;
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final HomeService _homeService = HomeService();
  
  Usuario usuario;
  String atividades = 'atividades';
  bool _iconeUp = false;

  HomeProvider(this.context) {
    _init();
  }

  _init() async {

    await _getAtividades();

    notifyListeners();
  }

  Future<void> _getAtividades() async {
    await _homeService.getAtividades().then((value) => atividades = value > 0
        ? 'Temos ' + value.toString() + ' atividades para hoje'
        : 'Nenhuma atividade para hoje');
  }

  String getUsuarioNome() {
    List primeiroNome;
    if (usuario?.nome != null) {
      primeiroNome = usuario.nome.split(' ');
      return 'Olá, ' + primeiroNome[0];
    }
    return 'Olá.';
  }

  void acumuladas(){
    if(_iconeUp){
      _iconeUp = false;
    } else {
      _iconeUp = true;
    }
    showIcon();
    notifyListeners();
  }
  Container showIcon() {
    if (_iconeUp) {
      return Container(
          child: Icon(Icons.expand_more,
              color: Colors.grey, //ThemeApp.Theme.primary,
              size: 25));
    } else {
      return Container(
          child: Icon(Icons.expand_less,
              color: Colors.grey, //ThemeApp.Theme.primary,
              size: 25));
    }
  }

  renderGridItemLinha(String texto, String rota, {IconData icone}) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () => {Navigator.pushNamed(context, rota)},
        child: Container(
          height: 102,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey[400],
                    offset: Offset(1, 1)),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (icone != null)
                Icon(icone, size: 20, color: ThemeApp.Theme.primary),
              if (icone != null) Padding(padding: EdgeInsets.all(6.0)),
              Text(texto, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }

  renderGridItemColuna(String texto, String rota, IconData icone) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () => {Navigator.pushNamed(context, rota)},
        child: Container(
          height: 78,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey[400],
                    offset: Offset(1, 1)),
              ]),
          child: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(6.0)),
              Icon(icone, size: 20, color: ThemeApp.Theme.primary),
              Padding(padding: EdgeInsets.all(6.0)),
              Text(texto)
            ],
          ),
        ),
      ),
    );
  }
}
