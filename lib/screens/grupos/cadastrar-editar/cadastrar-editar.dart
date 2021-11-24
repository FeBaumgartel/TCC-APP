import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/models/grupo.dart';
import 'package:tcc_app/services/dao/grupos.dart';

class CadastrarEditar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CadastrarEditarPage();
  }
}

class CadastrarEditarPage extends StatefulWidget {
  CadastrarEditarPage({Key key}) : super(key: key);

  @override
  _CadastrarEditarPageState createState() => _CadastrarEditarPageState();
}

class _CadastrarEditarPageState extends State<CadastrarEditarPage> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Pessoa Jurídica';
  Grupo grupo = Grupo();
  GruposService gruposService = GruposService();
  bool carregado = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerNome;
  TextEditingController _controllerDescricao;

  @override
  void initState() {
    super.initState();

    _controllerNome = TextEditingController(text: '');
    _controllerDescricao = TextEditingController(text: '');
  }

  String validateNome(String value) {
    if (value.length < 2) return 'Nome deve ter pelo menos 2 caracteres.';
    return null;
  }

  void _validateInputs() async {
    Grupo _grupo = Grupo();
    if (_formKey.currentState.validate()) {
      _grupo.nome = _controllerNome.text;
      _grupo.descricao = _controllerDescricao.text;
      
      var res;
      if (grupo.id == null) {
        res = await this.gruposService.insert(_grupo);
      } else {
        _grupo.id = grupo.id;
        res = await this.gruposService.updateGrupos(_grupo);
      }
      if (res != null) {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _construct(arguments) async {
    if (!carregado) {
      carregado = true;

      if (arguments['grupo'] != null) {
        this.setState(() {
          this.grupo = arguments['grupo'];

          _controllerNome.text = this.grupo.nome;
          _controllerDescricao.text = this.grupo.descricao;
        });
      }
    }
  }

  _renderWidget() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _controllerNome,
          decoration: InputDecoration(
            labelText: 'Nome',
          ),
          keyboardType: TextInputType.text,
          validator: validateNome,
        ),
        TextFormField(
          controller: _controllerDescricao,
          decoration: InputDecoration(
            labelText: 'Descricao',
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          validator: validateNome,
        ),
      ],
    );
  }

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context).settings.arguments;

    _construct(arguments);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: _validateInputs,
            child: Text('SALVAR'),
            textColor: Colors.white,
            disabledTextColor: Colors.white60,
          ),
        ],
        title: Text(
            arguments['grupo'] == null ? 'Novo Grupo' : 'Editar Grupo'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Container(child: _renderWidget())
            ],
          ),
        ),
      ),
    );
  }
}
