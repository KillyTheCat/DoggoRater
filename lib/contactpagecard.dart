import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String githuburl;
  ContactCard(this.name, this.githuburl);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$name',
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(height: 4),
            Text(
              githuburl,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
