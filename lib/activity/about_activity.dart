import 'package:flutter/material.dart';

class AboutActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset(
                'assets/images/profile.jpeg',
                height: 150,
                width: 150
              )
            ),
            SizedBox(
              height: 12
            ),
            Text(
              'Hai 👋 , saya Nur Fadilla Harun',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600
              )
            ),
            SizedBox(
              height: 7
            ),
            Text(
              'Teknik Informatika',
              style: TextStyle(
                fontSize: 15.0,
              )
            ),
            SizedBox(
              height: 3
            ),
            Text(
              'Politeknik Negeri Ambon',
              style: TextStyle(
                fontSize: 15.0,
              )
            ),
          ],
        )
      )
    );
  }
}
