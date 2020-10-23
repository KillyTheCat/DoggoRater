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
    FileHandler fileObj = FileHandler('scores.txt', '0\n0\n0\n0');
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
  Widget _doggo = Text('');
  bool _isDarkMode, _reloadImg;
  Color _bodyBgColor, _lowBodyColor, _questionTextColor, _buttonsBgColor;

  _MyAppState(_f) {
    _file = _f;
    _scores = [0, 0, 0];
    _isDarkMode = false;

    // Colors changing between Dark and Light mode
    _bodyBgColor = CupertinoColors.white;
    _questionTextColor = Colors.black;
    _buttonsBgColor = Colors.white60;
    _lowBodyColor = Colors.amber[300];

    // Enable file handling if not in Web app mode
    if (!kIsWeb) _file.readContent().then((value) => _scoreReader(value));
    _reloadImg = true;
  }

  void _scoreReader(String S) {
    int i = 0;
    for (String score in S.split('\n')) {
      if (i > 2)
        _isDarkMode = int.parse(score) == 1;
      else _scores[i++] = int.parse(score);
    }
    setState(() => _reloadImg = true);
  }

  void _answerQuestion(int responseType) {
    setState(() {
      // Rebuilds MyAppState
      _qid = responseType;

      // Give user another chance to try judging dogs accurately
      if (responseType == 99) {
        _scores = [0, 0, 0];
        _qid = 0;
      } else
        _scores[_qid]++;
    });
    _reloadImg = true;
  }

  void _darkLightSwitch() {
    if (_isDarkMode) {
      _bodyBgColor = CupertinoColors.darkBackgroundGray;
      _questionTextColor = Colors.white;
      _buttonsBgColor = Colors.black54;
      _lowBodyColor = Colors.black;
    } else {
      _bodyBgColor = CupertinoColors.white;
      _questionTextColor = Colors.black;
      _buttonsBgColor = Colors.white60;
      _lowBodyColor = Colors.amber[300];
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    // Build appearance based on Dark Mode Status
    _darkLightSwitch();

    // Set up initial orientation
    if (!_started) {
      _started = true;
      _orient = MediaQuery.of(context).orientation;
    }
    else {
      // Save scores and Dark Mode Status to file separated by \n
      int _darkModeStatus = (_isDarkMode) ? 1 : 0;
      if (!kIsWeb)
        _file.writeContent('${_scores[0]}\n${_scores[1]}\n${_scores[2]}\n$_darkModeStatus');
    }

    // Track orientation changes in each build
    _lOrient = _orient;
    _orient = MediaQuery.of(context).orientation;

    if (_lOrient != _orient || !_reloadImg)
      _doggo = ImageLoad(false, _scores[2]);
    else
      _doggo = ImageLoad(true, _scores[2]);

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
                  _scores[2],
                  _answerQuestion,
                  _doggo,
                  _height,
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
                  _scores[2],
                  _answerQuestion,
                  _doggo,
                  _height,
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
              _reloadImg = false;
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
