import 'package:flutter/material.dart';
import './text_input.dart';
import './photo_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaperC',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/photo': (context) => const ImagePickerPage(),
        '/text': (context) => MyWidget(
            defaultText: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaperC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/photo');
              },
              child: const Text('Photo input'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/text',
                    arguments: "Your default text here");
              },
              child: const Text('Text input'),
            ),
          ],
        ),
      ),
    );
  }
}
