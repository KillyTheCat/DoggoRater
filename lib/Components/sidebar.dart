import 'package:doggo_rater/Backend/downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBarDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final BuildContext _mainContext;
  final Function _getDogLink;

  SideBarDrawer(this._mainContext, this._scaffoldKey, this._getDogLink);

  // When download button pressed in Sidebar
  void downloadImage(String thisImageLink) async {
    try {
      // Saved with this method.
      Downloader dl = Downloader();
      String imageID = await dl.addDownload(thisImageLink);
      if (imageID == null) throw ('Download Failed!');
    } on PlatformException catch (error) {
      print(error);
    }
  }

  // URL launcher for downloading web files
  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      AlertDialog(
        title: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Text(
              'A Professional Sidebar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                letterSpacing: 1.5,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              if (_scaffoldKey.currentState.isDrawerOpen) {
                _scaffoldKey.currentState.openEndDrawer();
                Navigator.pushNamed(_mainContext, '/contact');
              }
            },
            leading: Icon(
              Icons.contacts,
            ),
            title: Text(
              'Contact us',
            ),
          ),
          ListTile(
            onTap: () {
              if (_scaffoldKey.currentState.isDrawerOpen)
                _scaffoldKey.currentState.openEndDrawer();
              if (!kIsWeb)
                downloadImage(_getDogLink());
              _launchURL(_getDogLink());
            },
            leading: Icon(
              Icons.download_rounded,
            ),
            title: Text(
              'Save this dog!',
            ),
          )
        ],
      ),
    );
  }
}
