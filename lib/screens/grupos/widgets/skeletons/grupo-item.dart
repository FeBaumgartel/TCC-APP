import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GrupoItem extends StatelessWidget {
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
                ]),
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
