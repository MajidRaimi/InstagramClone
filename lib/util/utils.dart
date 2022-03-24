import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/util/colors.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("No Image Selected");
}

showAlertDialog(String error, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Found Error"),
          content: Text(error),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              icon: const Icon(Icons.close, color: blueColor),
            )
          ],
        );
      });
}