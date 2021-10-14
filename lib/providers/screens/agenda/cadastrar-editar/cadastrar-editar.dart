import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/widgets/loading.dart';
import 'package:tcc_app/services/dao/eventos.dart';
import 'package:tcc_app/services/sessao.dart';

class CadastrarEditarProvider extends ChangeNotifier {
  final BuildContext context;
  
  EventosService _eventosService = new EventosService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool atendimento;
  Evento eventoParam;
  Evento evento;
  String dropdownValue;
  bool checkbox = false;
  bool checkboxEdit = false;
  bool autoValidate = false;
  DateTime minDate;
  DateTime dataInicio;
  DateTime dataFim;
  List<int> datas = List();
  bool enabled = true;
  bool enabledDatetime = true;
  String titulo = 'Editar Evento';
  List<int> usersId = List<int>();
  bool init = true;
  Usuario userAtual = Usuario();

  TextEditingController controllerDataInicio;
  TextEditingController controllerDataFim;
  TextEditingController controllerTitulo;

  CadastrarEditarProvider(this.context, this.eventoParam, this.atendimento) {
    if (eventoParam.id == null) {
      init = false;
      titulo = 'Novo Evento';
      usersId = [];
      controllerDataInicio = new TextEditingController(text: '');
      controllerDataFim = new TextEditingController(text: '');
      controllerTitulo = new TextEditingController(text: '');
    }
    _build();
  }

  refresh() => notifyListeners();

  Future<void> _build() async {
    this.evento = (eventoParam.id != null) 
      ? await this._eventosService.getEvento(eventoParam.id)
      : Evento();
    notifyListeners();
  }


  renderExcluir() {
    if (eventoParam.id != null) {
      return FloatingActionButton(
        onPressed: () {
            _excluirEventos(evento.id);
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

  _excluirEventos(id) async {
    bool forceDelete = false;
    if (evento.id == null) forceDelete = true;
    await this._eventosService.excluirEventos(id, checkboxEdit, forceDelete);
    Navigator.pop(context);
  }

  void carregaDadosEvento() {
    dataInicio = DateTime.parse(evento.dataInicio);
    dataFim = DateTime.parse(evento.dataFim);
    minDate = dataFim;
    datas = DateHelper.separaData(dataInicio);
    controllerDataInicio = new TextEditingController(
        text:
            DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(dataInicio));
    controllerDataFim = new TextEditingController(
        text: DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(dataFim));
    controllerTitulo = new TextEditingController(text: evento.nome);
  }

  void salvar() async {
    Evento _evento = Evento();
    if (formKey.currentState.validate()) {
      _evento.nome = controllerTitulo.text;
      _evento.dataInicio = (dataInicio.toString()).split('.000')[0];
      _evento.dataFim = (dataFim.toString()).split('.000')[0];

      var res;
      if (evento.id == null) {
        res = await this._eventosService.insert(_evento);
      } else {
        _evento.id = evento.id;
        res = await this
            ._eventosService
            .updateEventos(_evento);
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
