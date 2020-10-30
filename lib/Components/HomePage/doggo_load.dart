import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ImageLoad extends StatelessWidget {
  final Function(String, Widget) _sendDog;
  final Function _getScore;
  final _initURL = 'https://i.imgur.com/Tgqh5Hn.jpg?1';

  ImageLoad(this._getScore, this._sendDog);

  Future<String> fetchImg() async {
    final response = await http.get('https://dog.ceo/api/breeds/image/random');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body)['message'];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _out;
    String _currImage = _initURL;
    try {
      // If negative score >= 10, don't give more dogs.
      if (_getScore()[2] >= 10) {
        _out = Text(
          '\nYOU HAVE BEEN RIGHTLY RESTRICTED \nFROM USING THIS APP. \n\nPLEASE DO NOT CONTACT THE DEVELOPER.',
          textAlign: TextAlign.center,
          textScaleFactor: 1.7,
          style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
        );
      } else
        // Load Dog Link
        _out = FutureBuilder<String>(
          future: () {
            Future<String> fetched = fetchImg();
            if (fetched == null) throw 'e';
            return fetched;
          }(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _currImage = snapshot.data;
              _sendDog(_currImage, _out);
              // Load Dog Image
              return Image.network(_currImage, loadingBuilder:
                  (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                );
              });
            } else if (snapshot.hasError) throw (snapshot.error);
            // By default, show a loading spinner.
            return CircularProgressIndicator(
              backgroundColor: Colors.black,
            );
          },
        );
    }
    // If loading image Failed.
    catch (e) {
      _out = Column(children: [
        Flexible(
          flex: 5,
          child: Image.network(_currImage, loadingBuilder:
              (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            );
          }),
        ),
        Flexible(
          flex: 1,
          child: Text(
              'ERROR: Could Not Load Image in Time. Get Faster Internet!',
              style:
                  GoogleFonts.playfairDisplay(color: Colors.red, fontSize: 15)),
        ),
      ]);
    }

    // Send Image widget and link to Main.
    _sendDog(_currImage, _out);
    return _out;
  }
}
