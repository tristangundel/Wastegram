import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/wastepost_form.dart';

class NewWastePost extends StatefulWidget {

  static final routeName = "NewWastePost";

  @override
  _NewWastePost createState() => _NewWastePost();

}

class _NewWastePost extends State<NewWastePost> {

  File currentImage;

  Widget build(BuildContext context){
    currentImage = ModalRoute.of(context).settings.arguments;
    return (
      Scaffold(
        appBar: AppBar(
          title: Text("Wastegram")
        ),
        body: WastePostForm(currentImage: currentImage)
      )
    );
  }
}