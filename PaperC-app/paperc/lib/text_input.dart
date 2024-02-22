import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyWidget extends StatefulWidget {
  final String defaultText;

  const MyWidget({Key? key, this.defaultText = "Default Text"})
      : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final TextEditingController _textEditingController;
  String _response = '';

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.defaultText);
  }

  Future<void> _sendText() async {
    String text = _textEditingController.text;
    final apiUrl = Uri.parse('https://paperc.693147180.xyz/compile');
    var data = json.encode({"code": text});

    var response = await http.post(apiUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: data);
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String out = jsonResponse['reply']['out'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Reply"),
              content: Text(out),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Input',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Send Text via REST GET'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null, // Allows multiline input
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Enter text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendText,
                child: const Text('Send'),
              ),
              const SizedBox(height: 20),
              Text('Response: $_response'),
            ],
          ),
        ),
      ),
    );
  }
}
