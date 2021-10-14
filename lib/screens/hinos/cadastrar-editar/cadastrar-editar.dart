import 'package:flutter/material.dart';
import 'package:tcc_app/models/hino.dart';
import 'package:tcc_app/providers/screens/hinos/cadastrar-editar/cadastrar-editar.dart';
import 'package:tcc_app/screens/hinos/cadastrar-editar/widgets/layout.dart';
import 'package:provider/provider.dart';

class CadastrarEditarHino extends StatelessWidget {
  CadastrarEditarHino({this.hinoParam, this.atendimento});
  final Hino hinoParam;
  final bool atendimento;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CadastrarEditarProvider>(
      create: (context) => CadastrarEditarProvider(context, hinoParam, atendimento),
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
              if (model.hino != null && model.init) {
                model.carregaDadosHino();
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
