import 'package:flutter/material.dart';

import 'contact_page_card.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact the devs!'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        children: <Widget>[
          ContactCard('Dhi13man', 'https://github.com/Dhi13man'),
          ContactCard('Killythecat', 'https://github.com/killythecat'),
        ],
      ),
    );
  }
}
