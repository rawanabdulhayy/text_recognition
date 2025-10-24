import 'dart:io';

import 'package:image_picker/image_picker.dart';

//this class will only ever be changed if i change the way of cpickingimage onlt -- forst principle
class ImagePickerService{
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
    );
    //(Image Picker) XFile >> File
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}