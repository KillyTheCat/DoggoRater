import 'package:flutter/material.dart';

class Questions extends StatefulWidget {
  String _questionText;
  Color _questionColor;
  Questions(this._questionText, this._questionColor);

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget._questionText,
      style: TextStyle(
        color: widget._questionColor,
        fontSize: 20,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
