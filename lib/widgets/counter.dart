import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Counter extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  final int newCases;

  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
    this.newCases,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          NumberFormat("#,###", 'en_US').format(number).toString(),
          style: TextStyle(
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          "+${NumberFormat("#,###", 'en_US').format(newCases)}",
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}
