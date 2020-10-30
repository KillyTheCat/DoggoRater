import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatAppBar extends StatelessWidget {
  final List<int> _scores;

  StatAppBar(this._scores);

  @override
  Widget build(BuildContext context) {
    double size = 13;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Positive Ratings: ${_scores[0]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size,
            color: Colors.green[900],
          ),
        ),
        Text(
          "Indecisiveness: ${_scores[1]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size,
            color: Colors.white,
          ),
        ),
        Text(
          "Lies: ${_scores[2]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size,
            color: Colors.red[900],
          ),
        ),
      ],
    );
  }
}
