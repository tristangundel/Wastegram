import 'package:flutter/material.dart';
import './screens/new_wastepost.dart';
import './screens/wastepost_detail.dart';
import './screens/wastepost_list.dart';


class App extends StatelessWidget {

  static final routes = {
    NewWastePost.routeName: (context) => NewWastePost(),
    WastePostDetail.routeName: (context) => WastePostDetail(),
    WastePostList.routeName: (context) => WastePostList()
  };

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Wastegram',
      theme: ThemeData.dark(),
      routes: routes
    );
  }
}