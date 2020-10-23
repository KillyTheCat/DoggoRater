import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> fetchImg() async {
  final response = await http.get('https://dog.ceo/api/breeds/image/random');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body)['message'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

class ImageLoad extends StatelessWidget{
  final bool _genNew;
  static String _currImage;
  final int _score;

  ImageLoad(this._genNew, this._score);

  @override
  Widget build(BuildContext context) {
    if (_score >= 10) {// If negative score >= 10, don't give more dogs.
      return Text(
        '\nYOU HAVE BEEN RIGHTLY RESTRICTED \nFROM USING THIS APP. \n\nPLEASE DO NOT CONTACT THE DEVELOPER.',
        textAlign: TextAlign.center,
        textScaleFactor: 1.7,
        style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
      );
    }
    else return (_genNew) // Valid negative score to return Dog Image
        ? FutureBuilder<String>(
            future: fetchImg(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _currImage = snapshot.data;
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
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator(
                backgroundColor: Colors.black,
              );
            },
          )
        : Image.network(_currImage, loadingBuilder: (BuildContext context,
            Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
                child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ));
          });
  }
}
