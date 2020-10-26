import 'package:flutter/material.dart';

class SideBarDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final BuildContext _mainContext;
  SideBarDrawer(this._mainContext, this._scaffoldKey);

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
              if (_scaffoldKey.currentState.isDrawerOpen) {
                _scaffoldKey.currentState.openEndDrawer();
              }
              // TODO: Add stuff here to save the image of the dog to the phone, I would suggest using the browser module, you do you.
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
