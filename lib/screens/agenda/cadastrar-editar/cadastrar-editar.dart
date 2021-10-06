import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/providers/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/widgets/layout.dart';
import 'package:provider/provider.dart';

class CadastrarEditarEvento extends StatelessWidget {
  CadastrarEditarEvento({this.eventoParam, this.atendimento});
  final Evento eventoParam;
  final bool atendimento;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CadastrarEditarProvider>(
      create: (context) => CadastrarEditarProvider(context, eventoParam, atendimento),
      child:
          Consumer<CadastrarEditarProvider>(builder: (context, model, widget) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
               FlatButton(
                 onPressed: model.salvar,
                 child: Text("SALVAR"),
                 textColor: Colors.white,
                 disabledTextColor: Colors.white60,
               ),
            ],
            title: Text(model.titulo),
          ),
          body: Builder(
            builder: (BuildContext context) {
              if (model.evento != null && model.init) {
                model.carregaDadosEvento();
                model.init = false;
                return LayoutFormulario();
              } else if (!model.init) {
                return LayoutFormulario();
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: model.renderExcluir(),
        );
      }),
    );
  }
}
