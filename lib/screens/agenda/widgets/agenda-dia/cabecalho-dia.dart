import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CabecalhoDia extends StatelessWidget {
  final DateTime day;
  const CabecalhoDia(this.day, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            DateFormat("EEEE, dd 'de' MMMM 'de' y", "pt_BR")
                .format(day)
                .toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}
