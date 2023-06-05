// ignore_for_file: avoid_print

import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';

class ReceiptScanner {
  static Future<List<List<String>>> processImage(File imageFile) async {
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognisedText =
        await textRecognizer.processImage(inputImage);

    return _extractItemNamesAndPrices(recognisedText.blocks);
  }

  static List<List<String>> _extractItemNamesAndPrices(List<TextBlock> blocks) {
    final List<List<String>> result = [];
    for (TextBlock block in blocks) {
      for (TextLine line in block.lines) {
        final List<String> lineText = [];
        for (TextElement element in line.elements) {
          lineText.add(element.text);
        }
        result.add(lineText);
      }
    }
    return result;
  }
}

Future<void> main() async {
  // Replace 'imagePath' with the actual path to your image file
  String imagePath = 'path_to_your_image_file.jpg';
  File imageFile = File(imagePath);

  List<List<String>> extractedText =
      await ReceiptScanner.processImage(imageFile);

  // Filter item names and prices
  List<String> itemNames = [];
  List<String> prices = [];
  for (List<String> line in extractedText) {
    if (line.length >= 2) {
      String itemName = line[0]; // Item name
      String price = line[1]; // Price
      itemNames.add(itemName);
      prices.add(price);
    }
  }
}
