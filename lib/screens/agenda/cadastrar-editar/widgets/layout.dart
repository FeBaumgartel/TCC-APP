import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/helpers/date-helper.dart';
import 'package:tcc_app/models/grupo.dart';
import 'package:tcc_app/providers/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:provider/provider.dart';

class LayoutFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: model.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              _renderTitulo(),
              _renderDataInicio(),
              _renderDataFim(),
              Padding(
                padding: EdgeInsets.only(bottom: 65),
              ),
              FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Selecione um Grupo',
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: false,
                          child: DropdownButton(
                            value: model.selectGrupo,
                            isDense: true,
                            onChanged: (String newValue) {
                              model.selectGrupo = newValue;
                            },
                            items: model.grupos
                                .map<DropdownMenuItem<String>>((Grupo value) {
                              return new DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.nome));
                            }).toList(),
                          ),
                        ),
                      )
                    );
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  _renderDataInicio() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerDataInicio,
        readOnly: true,
        enabled: model.enabledDatetime,
        style: model.enabledDatetime
            ? TextStyle(color: Colors.black)
            : TextStyle(color: Colors.grey),
        decoration: const InputDecoration(
          labelText: 'Come??a',
          suffixIcon: Icon(FontAwesomeIcons.clock),
        ),
        keyboardType: TextInputType.text,
        validator: (str) => (model.controllerDataInicio.text == '')
            ? "O evento deve ter uma data inicial."
            : null,
        onTap: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(), onConfirm: (date) {
            model.minDate = date.add(Duration(hours: 1));
            model.datas = DateHelper.separaData(date);
            model.dataInicio = date;

            model.dataFim = model.minDate;
            model.controllerDataInicio.text =
                new DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR").format(date);
            model.controllerDataFim.text =
                DateFormat("dd 'de' MMMM',' y HH:mm", "pt_BR")
                    .format(model.minDate);
          }, currentTime: DateTime.now(), locale: LocaleType.pt);
          model.refresh();
        },
      );
    });
  }

  _renderDataFim() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerDataFim,
        readOnly: true,
        enabled: model.enabledDatetime,
        style: model.enabledDatetime
            ? TextStyle(color: Colors.black)
            : TextStyle(color: Colors.grey),
        decoration: const InputDecoration(
          labelText: 'Termina',
          suffixIcon: Icon(FontAwesomeIcons.clock),
        ),
        validator: (str) => (model.controllerDataFim.text == '')
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
            model.dataFim = date;
            model.controllerDataFim.text = time;
          }, currentTime: model.dataFim, locale: LocaleType.pt);
          model.refresh();
        },
      );
    });
  }

  _renderTitulo() {
    return Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
      return TextFormField(
        controller: model.controllerTitulo,
        decoration: const InputDecoration(
          labelText: 'T??tulo',
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        validator: (str) => (str.length < 2)
            ? "O t??tulo deve ter pelo menos 2 caracteres."
            : null,
      );
    });
  }
}
