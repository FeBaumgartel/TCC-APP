import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/models/item-pesquisa.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/widgets/loading.dart';
import 'package:tcc_app/services/dao/eventos.dart';
import 'package:tcc_app/services/dao/grupos_eventos.dart';
import 'package:tcc_app/services/sessao.dart';

class CadastrarEditarProvider extends ChangeNotifier {
  final BuildContext context;
  
  final Sessao? _sessao = Sessao.create();
  GruposEventosService _usuariosAgendaService = new GruposEventosService();
  EventosService _eventosService = new EventosService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool atendimento;
  Evento? eventoParam;
  Evento? evento;
  String? dropdownValue;
  String tipoVisita = 'Visita de vendas';
  bool checkbox = false;
  bool checkboxEdit = false;
  bool autoValidate = false;
  DateTime? minDate;
  DateTime? minDateRecore;
  int opcaoRecorrente = 0;
  String recorrentePeriodo = 'dia(s)';
  int opcaoLembrete = 1;
  int recorrente = 0;
  int? tipo;
  DateTime? dataInicial;
  DateTime? dataFinal;
  List<int> datas =[];
  int tiposVisita = 1;
  bool enabled = true;
  bool enabledDatetime = true;
  String titulo = 'Editar Evento';
  List<int> usersId = [];
  bool init = true;
  Usuario userAtual = Usuario();

  TextEditingController? controllerLocalizacao;
  TextEditingController? controllerDataInicial;
  TextEditingController? controllerDataFinal;
  TextEditingController? controllerDataFimRecorrente;
  TextEditingController? controllerCliente;
  TextEditingController? controllerClienteId;
  TextEditingController? controllerTitulo;
  TextEditingController? controllerQuantidadeRecorrencia;
  TextEditingController? controllerObservacaoInicial;
  TextEditingController? controllerObservacaoFinal;
  TextEditingController? controllerCadastradoPor;

  CadastrarEditarProvider(this.context, this.eventoParam, this.atendimento) {
    if (eventoParam!.id == null) {
      init = false;
      titulo = 'Novo Evento';
      controllerDataInicial = new TextEditingController(text: '');
      controllerDataFinal = new TextEditingController(text: '');
      controllerTitulo = new TextEditingController(text: '');
    }
    dropdownValue = atendimento ? 'Visita ao cliente' : 'Compromisso';
    tipo = atendimento ? 2 : 1;
    _build();
  }

  refresh() => notifyListeners();

  Future<void> _build() async {
    this.evento = (eventoParam!.id != null) 
      ? await this._eventosService.getEvento(eventoParam!.id!)
      : Evento();
    notifyListeners();
  } 

  renderExcluir() {
    if (eventoParam!.id != null) {
      return FloatingActionButton(
        onPressed: () {
          _excluirEventos(evento!.id);
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
    if (evento!.id == null) forceDelete = true;
    await this._eventosService.excluirEventos(id, checkboxEdit, forceDelete);
    Navigator.pop(context);
  }

  void carregaDadosEvento() {
    dataInicial = DateTime.parse(evento!.dataInicio!);
    dataFinal = DateTime.parse(evento!.dataFinal!);
    minDate = dataFinal;
    datas = DateHelper.separaData(dataInicial!);
    controllerDataInicial = new TextEditingController(
        text:
            DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(dataInicial!));
    controllerDataFinal = new TextEditingController(
        text: DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(dataFinal!));
    controllerTitulo = new TextEditingController(text: evento!.nome);

    controllerDataFimRecorrente = new TextEditingController(text: '');
  }

  void salvar() async {
    Evento _evento = Evento();
    if (formKey.currentState!.validate()) {
      _evento.nome = controllerTitulo!.text;
      _evento.dataInicio = (dataInicial.toString()).split('.000')[0];
      _evento.dataFinal = (dataFinal.toString()).split('.000')[0];

      var res;
      if (evento!.id == null) {
        res = await this._eventosService.insert(_evento);
      } else {
        _evento.id = evento!.id;
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
