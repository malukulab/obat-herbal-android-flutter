
import 'dart:io';

import 'package:flutter/material.dart';

class HerbShowActivity extends StatelessWidget {

  final Map<String, dynamic>? data;
  final String IMAGE_FALLBACK_PLECHOLDER = 'assets/images/placeholder.png';

  HerbShowActivity({Key? key, this.data}): super(key: key);



  List<Widget> _buildResolveImage(String? pathOfImage) {
    if (pathOfImage!.isNotEmpty) {
      return <Widget>[
        Image.file(File(pathOfImage))
      ];
    }

    return <Widget> [
      Image.asset(IMAGE_FALLBACK_PLECHOLDER),
      SizedBox(
        height: 10,
      ),
      Text(
        'Tidak menyertakan gambar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[700],
        )
      )
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data!['title']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ..._buildResolveImage(data!['photo']),
            SizedBox(
              height: 18
            ),
            Text(
              data!['title'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700
              )
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                data!['description'],
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16.5,
                  height: 1.5,
                )
              )
          ],
        )
      )
    );
  }
}