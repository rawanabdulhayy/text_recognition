import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_recognition/text_recognition_bloc.dart';
import 'package:text_recognition/text_recognition_state.dart';
import 'package:text_recognition/text_recognition_event.dart'; // <-- make sure you have events defined

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Recognition"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Camera Button
                GestureDetector(
                  onTap: () {
                    //Can I even do a context read in a block that ain't wrapped within a blocBuilder?
                    context
                        .read<TextRecognitionBloc>()
                        .add(PickImageEvent(ImageSource.camera)); // we have our source needed in triggering the events to differentiate whether it is a camera photo or a gallery one.
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.photo_camera_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Camera",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Gallery Button
                GestureDetector(
                  onTap: () {
                    context
                        .read<TextRecognitionBloc>()
                        .add(PickImageEvent(ImageSource.gallery));
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.photo_album, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Gallery",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Image Preview + Extracted Text (Bloc Controlled)
            BlocBuilder<TextRecognitionBloc, TextRecognitionState>(
              builder: (context, state) {
                if (state is TextRecognitionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TextRecognitionSuccess) {
                  return Column(
                    children: [
                      /// Image Preview Card
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                state.image, // coming from your bloc state
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Positioned X button
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Text(
                                  "X",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: (){
                                context.read<TextRecognitionBloc>().add(ClearImageEvent());
                              },
                            ),
                          ),
                        ],
                      ),

                      // Stack(
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.symmetric(
                      //           horizontal: 16, vertical: 8),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: Colors.white,
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.black.withOpacity(0.1),
                      //             spreadRadius: 2,
                      //             blurRadius: 6,
                      //             offset: const Offset(2, 4),
                      //           ),
                      //         ],
                      //       ),
                      //       height: 250,
                      //       child: ClipRRect(
                      //         borderRadius: BorderRadius.circular(15),
                      //         child: Image.file(
                      //           state.image, // coming from your bloc state
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.red,
                      //       ),
                      //       child: Text("X"),
                      //     ),
                      //   ],
                      // ),

                      /// Extracted Text Card
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Extracted Text:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.transcribedText, // from your bloc state
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is TextRecognitionError) {
                  return Center(
                      child: Text("Error: ${state.message} is encountered."));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
