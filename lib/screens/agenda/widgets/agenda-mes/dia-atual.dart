import 'package:flutter/material.dart';

class DiaAtual extends StatelessWidget {
  final DateTime date;
  const DiaAtual(this.date, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      margin: const EdgeInsets.all(4.0),
      width: 40,
      height: 40,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(fontSize: 16.0, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
