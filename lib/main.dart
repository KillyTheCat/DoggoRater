import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Backend/file_handling.dart';
import 'Components/ContactPage/contact_page.dart';
import 'Components/HomePage/body.dart';
import 'Components/HomePage/doggo_load.dart';
import 'Components/sidebar.dart';
import 'Components/statistic_app_bar.dart';

// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8989
void main() => runApp(AppHome());

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyApp(), routes: {'/contact': (context) => ContactPage()});
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
    'Fluffs doing an appreciate. RATE MORE',
    'Ew. RATE THE FLUFFFSSSS.',
    'Fluffy boi was heartbroken. BE NICE.',
  ];
  FileHandler _file;
  Widget _doggo;
  String _currDogLink;

  List<int> _scores;
  int _qid;

  bool _isDarkMode, _started;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Orientation _orient; // Orientation

  Color _bodyBgColor, _lowBodyColor, _questionTextColor, _buttonsBgColor;

  _MyAppState(_f) {
    // Backend Architecture
    _file = _f;
    _doggo = ImageLoad(getScores, getCurrentDog);

    // Main functionality of app
    _qid = 0;
    _scores = [0, 0, 0];

    // Flags required for operation
    _isDarkMode = false;
    _started = false;
    _scaffoldKey = GlobalKey<ScaffoldState>();

    // Light Mode initially.
    _bodyBgColor = CupertinoColors.white;
    _questionTextColor = Colors.black;
    _buttonsBgColor = Colors.white60;
    _lowBodyColor = Colors.amber[300];

    // Enable file handling if not in Web app mode
    if (!kIsWeb) _file.readContent().then((value) => _scoreReader(value));
  }

  void _scoreReader(String S) {
    int i = 0;
    for (String score in S.split('\n')) {
      if (i > 2)
        _isDarkMode = int.parse(score) == 1;
      else
        _scores[i++] = int.parse(score);
    }

    // Once Score is read from file, reload app.
    setState(() => _doggo = ImageLoad(getScores, getCurrentDog));
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

    _doggo = ImageLoad(getScores, getCurrentDog);
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

  List<int> getScores() => _scores;
  String sendDogLink() => _currDogLink;

  void getCurrentDog(String thisDog, Widget dog) {
    _currDogLink = thisDog;
    _doggo = dog;
  }

  @override
  Widget build(BuildContext context) {
    // Get current height and width of screen with every build
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    // Build appearance based on Dark Mode Status
    _darkLightSwitch();

    // Set up initial orientation
    if (!_started) {
      _started = true;
      _orient = MediaQuery.of(context).orientation;
    } else {
      // Save scores and Dark Mode Status to file separated by \n if not first run
      int _darkModeStatus = (_isDarkMode) ? 1 : 0;
      if (!kIsWeb)
        _file.writeContent(
            '${_scores[0]}\n${_scores[1]}\n${_scores[2]}\n$_darkModeStatus');

      // Track orientation changes in each build
      _orient = MediaQuery.of(context).orientation;
    }

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
            width: _width,
            child: StatAppBar(_scores),
          ),
          backgroundColor: _lowBodyColor,
        ),
        drawer: SideBarDrawer(context, _scaffoldKey, sendDogLink),
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
            setState(() => _isDarkMode = !_isDarkMode);
          },
          child: Icon(
            Icons.lightbulb,
            color: _bodyBgColor,
            size: 50.0,
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
      ),
    );
  }
}
