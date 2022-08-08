import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File) saveImage;
  const UserImagePicker(this.saveImage, {Key? key}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 200,
    );

    if (image == null) return;

    File imageFile = File(image.path);

    setState(() {
      _pickedImage = imageFile;
    });

    widget.saveImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
          child:
              _pickedImage == null ? const Icon(Icons.person, size: 50) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
