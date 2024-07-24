import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

   final void Function(File selectedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return UserImagePickerState();
  }
}

class UserImagePickerState extends State<UserImagePicker> {
  File? _imageSelected;

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _imageSelected = File(pickedImage.path);
    });

    widget.onPickImage(_imageSelected!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _imageSelected != null ? FileImage(_imageSelected!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text('Take photo', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
          icon: Icon(Icons.image ,color: Theme.of(context).colorScheme.primary,),
        )
      ],
    );
  }
}
