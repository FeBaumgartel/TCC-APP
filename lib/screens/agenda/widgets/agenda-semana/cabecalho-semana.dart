import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CabecalhoSemana extends StatelessWidget {
  final DateTime day;
  const CabecalhoSemana({Key key, @required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        children: <Widget>[
          Text(
            DateFormat.E("pt_BR").format(day),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width <= 360 ? 10 : 16),
          ),
          Text(
            "${day.day}",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    ));
  }
}
