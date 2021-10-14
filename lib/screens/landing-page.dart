import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tcc_app/services/database.dart';
// resetar dados no IOS
// import 'package:multiplier_app_novo/services/sessao.dart';

class LandingPage extends StatelessWidget {
  final _dbService = Database.create();

  @override
  Widget build(BuildContext context) {
    StreamSubscription dbPronto;

    dbPronto = _dbService.dbPronto
        .interval(Duration(milliseconds: 500))
        .listen((onValue) async {
      if (onValue) {
        dbPronto.cancel();
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
