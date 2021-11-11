import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  String validateEmail(String value) {
    if (value != null && value.replaceAll(' ', '') != '') {
      Pattern pattern =
          r'''^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) return 'Digite um Email válido.';
    }
    return null;
  }

  String validateTelefone(String value) {
    if (value != null && value.replaceAll(' ', '') != '') {
      String patttern = r'(\(\d{2}\)\s)(\d{4}\-\d{4})';
      RegExp regExp = RegExp(patttern);
      if (!regExp.hasMatch(value)) {
        return 'O número de telefone inválido';
      }
    }
    return null;
  }

  String validateCPF(String value) {
    if (value != null && value.replaceAll(' ', '') != '') {
      String patttern = r'^\d{3}\.\d{3}\.\d{3}\-\d{2}$';
      RegExp regExp = RegExp(patttern);
      if (!regExp.hasMatch(value)) {
        return 'O CPF é inválido';
      }
    }
    return null;
  }

  String validateCNPJ(String value) {
    if (value != null && value.replaceAll(' ', '') != '') {
      String patttern = r'^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$';
      RegExp regExp = RegExp(patttern);
      if (!regExp.hasMatch(value)) {
        return 'O CNPJ é inválido';
      }
    }
    return null;
  }

  String validateRua(String value) {
    if (value.length < 1) {
      return 'Digite o nome da rua';
    }
    return null;
  }

  String validateNumero(String value) {
    if (value.length < 1) {
      return 'Digite o número do endereço';
    }
    String patttern = r'[0,1,2,3,4,5,6,7,8,9]';
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch(value)) {
      return 'O número é inválido';
    }
    return null;
  }

  String validateBairro(String value) {
    if (value.length < 1) {
      return 'Digite o bairro';
    }
    return null;
  }

  String validateCidade(String value) {
    if (value.length < 1) {
      return 'Digite a cidade';
    }
    return null;
  }

  String validateEstado(String value) {
    if (value.length < 1) {
      return 'Informe o estado';
    }
    return null;
  }

  String validateCep(String value) {
    if (value != null && value.replaceAll(' ', '') != '') {
      String patttern = r'^\d{5}\-\d{3}$';
      RegExp regExp = RegExp(patttern);
      if (!regExp.hasMatch(value)) {
        return 'O CEP é inválido';
      }
    }
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
