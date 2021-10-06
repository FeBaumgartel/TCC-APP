import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/providers/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:provider/provider.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;

class LayoutFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: model.formKey,
          autovalidate: model.autoValidate,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Container(child: _renderWidget(model.dropdownValue, context)),
              _renderDataInicial(),
              _renderDataFinal(),
              if (model.evento.id != null) _renderCadastradoPor(),
              Padding(
                padding: EdgeInsets.only(bottom: 65),
              ),
            ],
          ),
        ),
      );
    });
  }

  _renderWidget(String _dropdownValue, BuildContext context) {
    if (_dropdownValue == 'Compromisso') {
      return Column(
        children: <Widget>[
          _renderTitulo(),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      );
    } else if (_dropdownValue == 'Visita ao cliente' ||
        _dropdownValue == 'Visita do cliente') {
      return Consumer<CadastrarEditarProvider>(
          builder: (context, model, widget) {
        return Column(
          children: <Widget>[
            _renderTitulo(),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        );
      });
    } else if (_dropdownValue == 'Reunião interna') {
      return Column(
        children: <Widget>[
          _renderTitulo(),
        ],
      );
    } else if (_dropdownValue == 'Lembretes') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          _renderTitulo(),
        ],
      );
    } else if (_dropdownValue == 'Videoconferência') {
      return Consumer<CadastrarEditarProvider>(
          builder: (context, model, widget) {
        return Column(
          children: <Widget>[
            _renderTitulo(),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        );
      });
    }
  }

  _renderDataInicial() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerDataInicial,
        readOnly: true,
        enabled: model.enabledDatetime,
        style: model.enabledDatetime
            ? TextStyle(color: Colors.black)
            : TextStyle(color: Colors.grey),
        decoration: const InputDecoration(
          labelText: 'Começa',
          suffixIcon: Icon(FontAwesomeIcons.clock),
        ),
        keyboardType: TextInputType.text,
        validator: (str) => (model.controllerDataInicial.text == '')
            ? "O evento deve ter uma data inicial."
            : null,
        onTap: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(), onConfirm: (date) {
            model.minDate = date.add(Duration(hours: 1));
            model.datas = DateHelper.separaData(date);
            model.dataInicial = date;

            model.dataFinal = model.minDate;
            model.controllerDataInicial.text =
                new DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(date);
            model.controllerDataFinal.text =
                DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR")
                    .format(model.minDate);
          }, currentTime: DateTime.now(), locale: LocaleType.pt);
          model.refresh();
        },
      );
    });
  }

  _renderDataFinal() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerDataFinal,
        readOnly: true,
        enabled: model.enabledDatetime,
        style: model.enabledDatetime
            ? TextStyle(color: Colors.black)
            : TextStyle(color: Colors.grey),
        decoration: const InputDecoration(
          labelText: 'Termina',
          suffixIcon: Icon(FontAwesomeIcons.clock),
        ),
        validator: (str) => (model.controllerDataFinal.text == '')
            ? "O evento deve ter uma data final."
            : null,
        keyboardType: TextInputType.text,
        onTap: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(model.datas[0], model.datas[1], model.datas[2],
                  model.datas[3], model.datas[4]), onConfirm: (date) {
            var time =
                new DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(date);
            model.dataFinal = date;
            model.controllerDataFinal.text = time;
          }, currentTime: model.dataFinal, locale: LocaleType.pt);
          model.refresh();
        },
      );
    });
  }

  _renderCadastradoPor() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerCadastradoPor,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Evento cadastrado por',
        ),
      );
    });
  }

  _renderTitulo() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerTitulo,
        decoration: const InputDecoration(
          labelText: 'Título',
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        validator: (str) => (str.length < 2)
            ? "O título deve ter pelo menos 2 caracteres."
            : null,
      );
    });
  }
}
