import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc_app/models/usuario.dart';
import 'package:tcc_app/routes.dart';
import 'package:tcc_app/services/dao/usuarios.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tcc_app/services/database.dart';

class Sessao {
  static Sessao sessao;
  final FlutterSecureStorage _storage = new FlutterSecureStorage();
  //ignore: close_sinks
  final BehaviorSubject<Usuario> usuario = new BehaviorSubject<Usuario>();
  String storageKey;

  Sessao._() {
    this.getUsuario().then((Usuario usuario) {
      if (usuario != null) {
        this.setUsuario(usuario);
      }
    });
  }

  static Sessao create() {
    if (sessao == null) {
      sessao = new Sessao._();
    }

    return sessao;
  }

  Future<void> setUsuario(Usuario usuario) async {
    if (usuario != null) {
      this.usuario.add(usuario);
      this.storageKey = 'multiplier.${usuario.id}';
      await this
          ._storage
          .write(key: this.storageKey, value: jsonEncode(usuario))
          .then((value) async {
        await this
            ._storage
            .write(key: 'usuario', value: jsonEncode(usuario))
            .catchError((error) => print(error));
      });
    } else {
      await this
          ._storage
          .write(key: this.storageKey, value: jsonEncode(usuario))
          .catchError((error) => print(error));
    }
  }

  Future<List<Usuario>> getUsuarios() async {
    Map<String, String> _storage = await this._storage.readAll();

    _storage.removeWhere((String chave, String valor) {
      return !chave.startsWith('multiplier.');
    });

    List<Usuario> usuarios = [];

    _storage.forEach((String chave, String valor) {
      dynamic obj = jsonDecode(valor);
      usuarios.add(
        new Usuario(
          id: obj['id'],
          nome: obj['nome'],
          email: obj['email']
        ),
      );
    });

    return usuarios;
  }

  Future<Usuario> getUsuario() async {
    return await this._storage.read(key: 'usuario').then((String usuario) async {
      dynamic obj = jsonDecode(usuario);

      return new Usuario(
        id: obj['id'],
        nome: obj['nome'],
        email: obj['email']
      );
    });
  }

  Future<String> getToken() async {
    return await this._storage.read(key: 'usuario').then((String usuario) {
      dynamic obj = jsonDecode(usuario);
      if (obj == null) {
        return '';
      }
      return obj['token'];
    }).catchError((e) {
      print(e);
      throw e;
    });
  }

  Future<void> setTheme(ThemeNotifier notifier) async {
    Color colorTheme = Colors.black;

    final defaultTheme = ThemeData(
      primaryColor: colorTheme,
      scaffoldBackgroundColor: Color(0xFFFAFAFA),
      cardColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorTheme,
        focusColor: colorTheme,
      ),
      accentColor: colorTheme,
      hintColor: colorTheme,
      primaryIconTheme: IconThemeData(
        color: colorTheme,
      ),
      bottomAppBarColor: colorTheme,
      buttonColor: colorTheme,
      indicatorColor: colorTheme,
      splashColor: colorTheme,
      cursorColor: colorTheme,
      appBarTheme: AppBarTheme(
        color: colorTheme,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colorTheme,
      ),
      iconTheme: IconThemeData(
        color: colorTheme,
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: colorTheme, disabledColor: colorTheme.withAlpha(75)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorTheme,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: colorTheme,
      ),
      fontFamily: 'UBUNTU',
      textTheme: TextTheme(
        button: TextStyle(
          color: colorTheme.withAlpha(100),
        ),
      ),
    );

    notifier.setTheme(defaultTheme);
  }

  Future<void> restore() async {
    await _storage.deleteAll();
  }
}
