import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  var pickedFile = null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image == null)
              const Text('No image selected.')
            else
              Image.file(_image!),
            if (_response != null) Text(_response!),
            ElevatedButton(
              onPressed: sendImage,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: getImageFromCamera,
            tooltip: 'Take Photo',
            child: const Icon(Icons.add_a_photo),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: getImageFromGallery,
            tooltip: 'Choose from Gallery',
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    ));
  }

  File? _image;
  String? _response;

  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final _pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (_pickedFile != null) {
      setState(() {
        pickedFile = _pickedFile;
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromGallery() async {
    final _pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      setState(() {
        pickedFile = _pickedFile;
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> sendImage() async {
    final apiUrl = Uri.parse('https://paperc.693147180.xyz/ocr');

    if (_image == null) {
      setState(() {
        _response = 'No image selected.';
      });
      return;
    }

    final imagePath = _image!.path;

    try {
      var request = http.MultipartRequest('GET', apiUrl);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String ocr = jsonResponse['reply']['ocr'];
        Navigator.pushNamed(context, '/text', arguments: ocr);
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
}
