import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import './text_input.dart';
import './photo_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaperC',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/photo': (context) => ImagePickerPage(),
        '/text': (context) => MyWidget(
            defaultText: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaperC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/photo');
              },
              child: Text('Photo input'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/text',
                    arguments: "Your default text here");
              },
              child: Text('Text input'),
            ),
          ],
        ),
      ),
    );
  }
}
