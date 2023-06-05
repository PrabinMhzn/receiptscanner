import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receiptscanner/reciept_scanner.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({Key? key}) : super(key: key);

  @override
  ReceiptScannerScreenState createState() => ReceiptScannerScreenState();
}

class ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  File? _image;
  List<List<String>> _extractedText = [];

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _processImage() async {
    if (_image != null) {
      _extractedText = await ReceiptScanner.processImage(_image!);
      showDataExtractedDialog();
    }
  }

  void showDataExtractedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Extracted'),
          content: Text(
            'Text extracted from receipt:\n${_extractedText.toString()}',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) Image.file(_image!),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Photo'),
            ),
            ElevatedButton(
              onPressed: _processImage,
              child: const Text('Process Image'),
            ),
          ],
        ),
      ),
    );
  }
}
