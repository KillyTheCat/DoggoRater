import 'package:flutter/material.dart';

class Answers extends StatefulWidget {
  final Function(int) _answerQuestion;
  final Color bgColor;

  Answers(this._answerQuestion, this.bgColor);

  @override
  _AnswersState createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      color: widget.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            child: RaisedButton(
              child: Text('Good Boi'),
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () => widget._answerQuestion(0),
              padding: EdgeInsets.symmetric(horizontal: _width / 5),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          ClipRRect(
            child: RaisedButton(
              child: Text(
                'I have crippling decision anxiety.',
              ),
              onPressed: () => widget._answerQuestion(1),
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: _width / 5 - 70),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          ClipRRect(
            child: RaisedButton(
                child: Text('Heckin floofer'),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () => widget._answerQuestion(2),
                padding: EdgeInsets.symmetric(horizontal: _width / 5 - 15)),
            borderRadius: BorderRadius.circular(15),
          ),
        ],
      ),
    );
  }
}
