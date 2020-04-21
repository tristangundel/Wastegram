import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/new_wastepost.dart';
import 'package:image_picker/image_picker.dart';

class CameraAccessButton extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return (
      Padding(
        padding: EdgeInsets.all(15),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            getImage(context);
          }
        )
      )
    );
  }

  void getImage(BuildContext context) async {
    Future<File> image = ImagePicker.pickImage(source: ImageSource.gallery);
    image.then((value) {
      print(value.toString());
      Navigator.of(context).pushNamed(NewWastePost.routeName, arguments: value);
    });
  }
}