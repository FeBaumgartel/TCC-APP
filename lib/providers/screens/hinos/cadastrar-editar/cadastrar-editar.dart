import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/models/hino.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/screens/hinos/cadastrar-editar/widgets/loading.dart';
import 'package:tcc_app/services/dao/hinos.dart';
import 'package:tcc_app/services/sessao.dart';

class CadastrarEditarProvider extends ChangeNotifier {
  final BuildContext context;
  
  HinosService _hinosService = new HinosService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool atendimento;
  Hino hinoParam;
  Hino hino;
  String dropdownValue;
  bool checkbox = false;
  bool checkboxEdit = false;
  bool autoValidate = false;
  bool enabled = true;
  bool enabledDatetime = true;
  String titulo = 'Editar Hino';
  List<int> usersId = List<int>();
  bool init = true;
  Usuario userAtual = Usuario();

  TextEditingController controllerLetra;
  TextEditingController controllerTitulo;

  CadastrarEditarProvider(this.context, this.hinoParam, this.atendimento) {
    if (hinoParam.id == null) {
      init = false;
      titulo = 'Novo Hino';
      usersId = [];
      controllerLetra = new TextEditingController(text: '');
      controllerTitulo = new TextEditingController(text: '');
    }
    _build();
  }

  refresh() => notifyListeners();

  Future<void> _build() async {
    this.hino = (hinoParam.id != null) 
      ? await this._hinosService.getHino(hinoParam.id)
      : Hino();
    notifyListeners();
  }


  renderExcluir() {
    if (hinoParam.id != null) {
      return FloatingActionButton(
        onPressed: () {
            _excluirHinos(hino.id);
        },
        child: Icon(FontAwesomeIcons.trashAlt),
        backgroundColor: Theme.of(context).primaryColor,
      );
    } else {
      return Center(
        child: null,
      );
    }
  }

  _excluirHinos(id) async {
    bool forceDelete = false;
    if (hino.id == null) forceDelete = true;
    await this._hinosService.excluirHinos(id, checkboxEdit, forceDelete);
    Navigator.pop(context);
  }

  void carregaDadosHino() {
    controllerTitulo = new TextEditingController(text: hino.nome);
    controllerLetra = new TextEditingController(text: hino.letra);
  }

  void salvar() async {
    Hino _hino = Hino();
    if (formKey.currentState.validate()) {
      _hino.nome = controllerTitulo.text;
      _hino.letra = controllerLetra.text;

      var res;
      if (hino.id == null) {
        res = await this._hinosService.insert(_hino);
      } else {
        _hino.id = hino.id;
        res = await this
            ._hinosService
            .updateHinos(_hino);
      }

      if (res != null) {
        Navigator.pop(context);
      }
    } else {
      autoValidate = true;
      notifyListeners();
    }
  }  
}
