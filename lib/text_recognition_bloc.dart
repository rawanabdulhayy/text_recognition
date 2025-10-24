import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_recognition/services/image_picker_service.dart';
import 'package:text_recognition/services/text_recognition_service.dart';
import 'package:text_recognition/text_recognition_event.dart';
import 'package:text_recognition/text_recognition_state.dart';

class TextRecognitionBloc
    extends Bloc<TextRecognitionEvent, TextRecognitionState> {

  // final ImagePicker _imagePicker = ImagePicker();
  // final TextRecognizer _textRecognizer = TextRecognizer();

  final ImagePickerService imagePickerService;
  final TextRecognitionService textRecognitionService;

  //the processor
  TextRecognitionBloc({required this.imagePickerService, required this.textRecognitionService, required RecognitionService}) : super(TextRecognitionInitial()) {
    on<PickImageEvent>(
            (event, emit) async {
      try {
        emit(TextRecognitionLoading());

        // final XFile? pickedFile = await _imagePicker.pickImage(
        //   source: event.source,
        // );

        final File? image = await imagePickerService.pickImage(event.source);
        if (image == null) {
          emit(TextRecognitionInitial());
        }

        final text = await textRecognitionService.recognizeText(image);
        // //Recognized text package offers a converter for the xFile (ImagePicker returned type) to the needed type inputImage(TextRecogniser), via a bridge that converts the ImagePicker into a (file).
        //
        // //validation for the picking process success
        // if (pickedFile != null) {
        //   //the bridge converter - file >> file = step (1).path
        //   final File tempFile = File(pickedFile.path);
        //   final InputImage inputImage = InputImage.fromFile(tempFile);
        //   final RecognizedText recognizedText = await _textRecognizer
        //       .processImage(inputImage);
        //   //takes a file type image, not an inputImage.
          emit(TextRecognitionSuccess(image!, text));

        // //haven't picked a photo, tried so and cancelled midway.
        // else {
        //   emit(TextRecognitionInitial());
        // }
      } catch (e) {
        emit(TextRecognitionError(e.toString()));
      }
    });

    on<ClearImageEvent>((event, emit) async {
      emit(TextRecognitionInitial());
    });
  }
  // @override
  // Future<void> close() {
  //   _textRecognizer.close();
  //   return super.close();
  // }
}
