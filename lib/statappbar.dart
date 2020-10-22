import 'package:flutter/cupertino.dart';

class StatAppBar extends StatelessWidget {
  final List<int> _scores;
  StatAppBar(this._scores);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Positive Ratings: ${_scores[0]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          "Indecisiveness: ${_scores[1]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          "Lies: ${_scores[2]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
