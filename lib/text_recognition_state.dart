import 'dart:io';

abstract class TextRecognitionState {}

class TextRecognitionInitial extends TextRecognitionState {}

class TextRecognitionLoading extends TextRecognitionState {}

class TextRecognitionSuccess extends TextRecognitionState {
  final File image;
  final String transcribedText;
  TextRecognitionSuccess(this.image, this.transcribedText);
}

class TextRecognitionError extends TextRecognitionState {
  final String message;
  TextRecognitionError(this.message);
}
