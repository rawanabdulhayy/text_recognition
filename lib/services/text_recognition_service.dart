import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  // (Image Picker) XFile >> File >> (Text Recognition) Input Image.

  Future <String> recognizeText(File? image) async {
    final inputImage = InputImage.fromFile(image!);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  void dispose(){
    _textRecognizer.close();
  }

}