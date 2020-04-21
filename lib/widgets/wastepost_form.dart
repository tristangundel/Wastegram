
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/wastepostDTO.dart';

class WastePostForm extends StatefulWidget {

  final File currentImage;

  WastePostForm({this.currentImage});

  @override
  _WastePostForm createState() => _WastePostForm(currentImage: currentImage);
}

class _WastePostForm extends State<WastePostForm> {

  final formKey = GlobalKey<FormState>();
  final wastepostDTO = WastePostDTO();
  var locationData;
  File currentImage;

  _WastePostForm({this.currentImage});

  @override
  Widget build(BuildContext context){
    if(currentImage != null){
      return(
        Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30, width: 30),
                  Container(child: Image.file(currentImage), width: 300, height: 400),
                  SizedBox(height: 30, width: 30),
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity of Items',
                      border: OutlineInputBorder()
                    ),
                    onSaved: (value) {
                      wastepostDTO.quantity = int.parse(value);
                    },
                    validator: (value) {
                      if (value.isEmpty){
                        return 'Please enter a quantity of items';
                      } else {
                        return null;
                      }
                    }
                  ),
                  SizedBox(height: 50),
                  saveButton(context)
                ]
              )
            )
          )
        )
      );
    } else {
      return(Center(child: CircularProgressIndicator()));
    }
  }

  Widget saveButton(BuildContext context){
    return (
      ButtonTheme(
        minWidth: 250,
        height: 75,
        child: RaisedButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            if (formKey.currentState.validate()){
              saveLocationData();
              saveDate();
              formKey.currentState.save();
              StorageReference storageReference = 
                FirebaseStorage.instance.ref().child("WastePhoto_${DateTime.now()}");
              StorageUploadTask uploadTask = storageReference.putFile(currentImage);
              Future result = uploadTask.onComplete;
              result.then((value){
                Future url = storageReference.getDownloadURL();
                url.then((value) {
                  print(value);
                  wastepostDTO.imageURL = value;
                  Firestore.instance.collection('posts').add({
                  'date': wastepostDTO.date,
                  'quantity': wastepostDTO.quantity,
                  'imageURL': wastepostDTO.imageURL,
                  'latitude': wastepostDTO.latitude,
                  'longitude': wastepostDTO.longitude
                  });
                });
              });

              popNewWastePost(context);
          }
        })
      )
    );
  }

  void saveLocationData() {
    Location locationService = Location();
    Future locationData = locationService.getLocation();
    locationData.then((value) {
      print(value.latitude);
      print(value.longitude);
      wastepostDTO.latitude = value.latitude;
      wastepostDTO.longitude = value.longitude;
    });
  } 

  void saveDate() {
    wastepostDTO.date = DateTime.now();
  }

  void saveImageURL() {
    StorageReference storageReference = 
      FirebaseStorage.instance.ref().child("WastePhoto_${DateTime.now()}");
    StorageUploadTask uploadTask = storageReference.putFile(currentImage);
    Future result = uploadTask.onComplete;
    result.then((value){
      Future url = storageReference.getDownloadURL();
      url.then((value) {
        print(value);
        wastepostDTO.imageURL = value;
      });
    });
  }

  void popNewWastePost(BuildContext context){
    Navigator.of(context).pop();
  }

}