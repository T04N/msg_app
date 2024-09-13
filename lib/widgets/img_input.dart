import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage)   onPickImage;


  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _imagePicked;

  Future<void> _picKImage() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 159);
    if (img == null) return;
    setState(() {
      _imagePicked = File(img.path);
    });

    widget.onPickImage(_imagePicked!);

  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.green,
        foregroundImage: _imagePicked != null ? FileImage(_imagePicked!) : null,
      ),
      TextButton.icon(
        onPressed: _picKImage,
        icon: const Icon(Icons.image),
        label: const Text("Add Image"),
      ),
    ]);
  }
}
