import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HinoItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      margin: EdgeInsets.fromLTRB(16.0, 5, 16.0, 5),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[300],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 10, 8),
                          child: Text(
                            'aaaaaaaaaaaaaaaa',
                            style: TextStyle(
                              background: Paint(),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'aaa',
                          style: TextStyle(
                            background: Paint(),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 5,
                          ),
                        ),
                        Text(
                          'Ativo',
                          style: TextStyle(
                            background: Paint(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 15,
                          ),
                        ),
                      ],
                    ),
                  ])
                ]),
            Row(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 15, bottom: 15),
                  child: Text(
                    '00.000.000/0000-00',
                    style: TextStyle(
                      background: Paint(),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text(
                        'aaa',
                        style: TextStyle(
                          background: Paint(),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Text(
                        'aaaaaaaaaaaaaaa',
                        style: TextStyle(
                          background: Paint(),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text(
                        'aaa',
                        style: TextStyle(
                          background: Paint(),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Text(
                        '(00) 00000-0000',
                        style: TextStyle(
                          background: Paint(),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text(
                        'aaa',
                        style: TextStyle(
                          background: Paint(),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Text(
                        'email@email.com.br',
                        style: TextStyle(
                          background: Paint(),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
