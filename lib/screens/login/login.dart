import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/routes.dart';
import 'package:tcc_app/services/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) => LoginPage(context: context);
}

class LoginPage extends StatefulWidget {
  final BuildContext context;
  LoginPage({Key key, this.context}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  ThemeNotifier themeNotifier;

  dynamic _arguments;

  TextEditingController _email = new TextEditingController();
  TextEditingController _senha = new TextEditingController();
  final UsuariosService usuariosService = new UsuariosService();

  Animation<double> _formAnimation;
  AnimationController _formAnimationController;
  Animation<double> _degradeAnimation;
  AnimationController _degradeAnimationController;
  Animation<num> _logoAnimation;
  AnimationController _logoAnimationController;
  Animation<num> _formOpacityAnimation;
  AnimationController _formOpacityAnimationController;

  @override
  void initState() {
    super.initState();
    _formAnimationController = new AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _formOpacityAnimationController = new AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _degradeAnimationController = new AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _logoAnimationController = new AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    setState(() {
      themeNotifier = Provider.of<ThemeNotifier>(widget.context);
      _arguments = ModalRoute.of(widget.context).settings.arguments;

      _degradeAnimation =
          Tween(begin: 1.0, end: 0.5).animate(_degradeAnimationController)
            ..addListener(() {
              setState(() {});
            });
      _formAnimation =
          Tween(begin: MediaQuery.of(widget.context).size.height, end: 0.0)
              .animate(_formAnimationController);
      _formOpacityAnimation =
          Tween(begin: 0, end: 1.0).animate(_formOpacityAnimationController)
            ..addListener(() {
              setState(() {});
            });

      _logoAnimation =
          Tween(begin: 0, end: (MediaQuery.of(widget.context).size.width) - 90)
              .animate(_logoAnimationController)
                ..addStatusListener((AnimationStatus status) {
                  if (status == AnimationStatus.completed) {
                    _degradeAnimationController.forward();
                    _formAnimationController.forward();
                    _formOpacityAnimationController.forward();
                  }
                });

      _logoAnimationController.forward();
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Eroo"),
              content: new Text("Email ou senha inválido"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  ScaffoldFeatureController _scafoldController;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFAFAFA),
                    Theme.of(context).primaryColor,
                  ],
                  stops: [
                    _degradeAnimation.value,
                    1
                  ]),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _logoAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      builder: (BuildContext context, Widget child) {
                        return Container(
                          height: double.parse(_logoAnimation.value.toString()),
                          child: child,
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _formAnimation,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                FormField(builder: (FormFieldState state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Email',
                                    ),
                                    child: TextFormField(
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Digite o e-mail';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                }),
                                FormField(builder: (FormFieldState state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Senha',
                                    ),
                                    child: TextFormField(
                                      controller: _senha,
                                      keyboardType: TextInputType.emailAddress,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Digite a senha';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                }),
                                FormField(builder: (FormFieldState state) {
                                  return MaterialButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      color: Theme.of(context).primaryColor,
                                      textColor: Color(0xFFFFFFFF),
                                      child: Text('Entrar'),
                                      onPressed: () async {
                                        var email = this._email.text;
                                        var senha = this._senha.text;
                                        Usuario usuario = await usuariosService
                                            .validarLogin(email, senha);
                                        if (usuario != null) {
                                          await Navigator.pushNamed(
                                              context, '/landingpage',
                                              arguments: {'usuario': usuario});
                                        } else {_showDialog();}
                                      });
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      builder: (BuildContext context, Widget child) {
                        return Opacity(
                          opacity: double.parse(
                              _formOpacityAnimation.value.toString()),
                          child: Transform.translate(
                            offset: Offset(0, _formAnimation.value),
                            child: child,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    _logoAnimationController.dispose();
    _degradeAnimationController.dispose();
    _formOpacityAnimationController.dispose();
    super.dispose();
  }
}