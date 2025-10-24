import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_recognition/presentation/screens/main_screen.dart';
import 'package:text_recognition/services/image_picker_service.dart';
import 'package:text_recognition/services/text_recognition_service.dart';
import 'package:text_recognition/text_recognition_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextRecognitionBloc(
        imagePickerService: ImagePickerService(),
        textRecognitionService: TextRecognitionService(), RecognitionService: null,
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MainScreen(),
      ),
    );
  }
}
