import 'package:image_picker/image_picker.dart';

abstract class TextRecognitionEvent{}

class PickImageEvent extends TextRecognitionEvent{
  final ImageSource source;
  PickImageEvent(this.source);
}
class ClearImageEvent extends TextRecognitionEvent{}
