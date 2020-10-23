import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:doggo_rater/questions.dart';
import 'package:doggo_rater/answers.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> bodyItems(
    String question,
    List<int> _scores,
    Function(int) _answerQuestion,
    Widget _doggo,
    double _height,
    double _width,
    String o,
    Color bodyBackgroundColor,
    Color questionTextColor,
    Color buttonBackgroundColor,
    Color lowerBodyColor) {
  return [
    Flexible(
      flex: 2,
      child: Container(
        color: bodyBackgroundColor,
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
              width: double.infinity,
              color: lowerBodyColor,
              child: Answers(_answerQuestion, lowerBodyColor))
          : Flexible(
              flex: 2,
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: lowerBodyColor,
                  child: Answers(_answerQuestion, lowerBodyColor))),
    if (_doggo is Text)
      Flexible(
        flex: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          color: lowerBodyColor,
          child: RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              'I have made a severe and continuous lapse in my Judgement. Please reset.',
              style: GoogleFonts.bubblegumSans(
                  fontSize: 20, color: questionTextColor),
              textAlign: TextAlign.center,
            ),
            onPressed: () => _answerQuestion(99),
            color: buttonBackgroundColor,
          ),
        ),
      )
  ];
}
