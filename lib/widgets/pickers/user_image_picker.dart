import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickerHandler;

  UserImagePicker({@required this.imagePickerHandler});
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final PickedFile pickedImageData = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 72,
      maxWidth: 150,
    );
    final File pickedImageFile = File(pickedImageData.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickerHandler(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _pickedImage != null
                ? FileImage(
                    _pickedImage,
                  )
                : null,
          ),
          FlatButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add Image'),
          ),
        ],
      ),
    );
  }
}
