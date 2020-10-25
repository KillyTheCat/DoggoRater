import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:doggo_rater/questions.dart';
import 'package:doggo_rater/answers.dart';

List<Widget> bodyItems(
  String question,
  List<int> _scores,
  Function(int) _answerQuestion,
  Widget _doggo,
  double _height,
  double _width,
  String o,
  Color bgcolor,
  Color questionTextColor,
  Color bgcolor2,
) {
  return [
    Flexible(
      flex: 1,
      child: Container(
        color: bgcolor,
        width: double.infinity,
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Questions(question, questionTextColor),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: _height / 2,
                child: _doggo,
              )),
        ]),
      ),
    ),
    if (!(_doggo is Text))
      (o == 'p')
          ? Container(
              width: double.infinity, child: Answers(_answerQuestion, bgcolor2))
          : Flexible(
              flex: 1,
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Answers(_answerQuestion, bgcolor2))),
  ];
}
