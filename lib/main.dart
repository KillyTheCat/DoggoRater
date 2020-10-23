import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:doggo_rater/doggoload.dart';
import 'package:doggo_rater/body.dart';
import 'statappbar.dart';
import 'filehandling.dart';

// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8989
void main() => runApp(AppHome());

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    FileHandler fileObj = FileHandler('scores.txt');
    if (!kIsWeb && !fileObj.exists()) fileObj.writeContent('0\n0\n0');
    return _MyAppState(fileObj);
  }
}

class _MyAppState extends State<MyApp> {
  static const _questions = [
    'Rate Da FLUFFY BOI',
    'Fluffs doin appreciate. RATE MORE',
    'Ew. RATE THE FLUFFFSSSS',
    'Fluffy boi was heartbroken. BE NICE.',
  ];
  var _qid = 0, _started = false;
  List<int> _scores;
  Orientation _orient;
  FileHandler _file;
  var _lOrient = Orientation.portrait;
  Widget _doggo;
  bool _isDarkMode;
  Color _bodyBgColor = CupertinoColors.darkBackgroundGray, _lowBodyColor = Colors.black;
  Color _questionTextColor = Colors.white;
  Color _buttonsBgColor = Colors.black54;

  _MyAppState(_f) {
    _file = _f;
    _scores = [0, 0, 0];
    _isDarkMode = true;
    _doggo = ImageLoad(true);

    if (_file.permissionGiven() && !kIsWeb && !_file.exists())
      _file.writeContent('0\n0\n0');

    if (!kIsWeb) _file.readContent().then((value) => _scoreReader(value));
  }

  void _scoreReader(String S) {
    int i = 0;
    for (String score in S.split('\n')) _scores[i++] = int.parse(score);
  }

  void _answerQuestion(int responseType) {
    setState(() {
      // Rebuilds MyAppState
      _qid = responseType;

      if (responseType == 99) {
        _scores = [0, 0, 0];
        _qid = 0;
        _scores[_qid] = -1;
      }
      _scores[_qid]++;

      if (_scores[2] >= 10) {
        _doggo = Text(
          '\nYOU HAVE BEEN RIGHTLY RESTRICTED \nFROM USING THIS APP. \n\nPLEASE DO NOT CONTACT THE DEVELOPER.',
          textAlign: TextAlign.center,
          textScaleFactor: 1.7,
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        );
        _scores[_qid]--;
        _qid = 2;
        _scores[_qid] = 10;
      } else {
        _doggo = ImageLoad(true);
        if (!kIsWeb)
          _file.writeContent('${_scores[0]}\n${_scores[1]}\n${_scores[2]}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    // Set up initial orientation
    if (!_started) {
      _started = true;
      _orient = MediaQuery.of(context).orientation;
    }
    // Track orientation changes in each build
    _lOrient = _orient;
    _orient = MediaQuery.of(context).orientation;

    if (_lOrient != _orient && !(_doggo is Text)) _doggo = ImageLoad(false);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            width: _width,
            child: StatAppBar(_scores),
          ),
          backgroundColor: _lowBodyColor,
        ),
        body: (_orient == Orientation.portrait)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: bodyItems(
                    _questions[_qid + 1],
                    _scores,
                    _answerQuestion,
                    _doggo,
                    _height,
                    _width,
                    'p',
                    _bodyBgColor,
                    _questionTextColor,
                    _buttonsBgColor,
                    _lowBodyColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: bodyItems(
                    _questions[_qid + 1],
                    _scores,
                    _answerQuestion,
                    _doggo,
                    _height,
                    _width,
                    'l',
                    _bodyBgColor,
                    _questionTextColor,
                    _buttonsBgColor,
                    _lowBodyColor,
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
              if (_isDarkMode) {
                _bodyBgColor = CupertinoColors.darkBackgroundGray;
                _questionTextColor = Colors.white;
                _buttonsBgColor = Colors.black54;
                _lowBodyColor = Colors.black;
              } else {
                _bodyBgColor = CupertinoColors.white;
                _questionTextColor = Colors.black;
                _buttonsBgColor = Colors.white60;
                _lowBodyColor = Colors.amber;
              }
            });
          },
          child: Icon(
            Icons.lightbulb,
            size: 50.0,
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
      ),
    );
  }
}
