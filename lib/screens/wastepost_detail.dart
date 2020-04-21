import 'package:flutter/material.dart';
import '../models/wastepost.dart';

class WastePostDetail extends StatelessWidget {

  static final routeName = "WastePostDetail";

  String getDateFormat(DateTime date){
    List<String> weekdays = [ "Monday", "Tuesday", "Wednesday", "Thursday", 
                            "Friday", "Saturday", "Sunday" ];
                            
    List<String> months = [ "Jan.", "Feb.", "Mar.", "Apr.", 
                          "May", "Jun.", "Jul.", "Aug.", 
                          "Sep.", "Oct.", "Nov.", "Dec." ];
                          
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget build(BuildContext context){

    final WastePost post = ModalRoute.of(context).settings.arguments;

    return (
      Scaffold(
        appBar: AppBar(
          title: Text("Wastegram")
        ),
        body: Center(
          child: 
          Padding(
              padding: EdgeInsets.all(10),
              child: Column(
              children: <Widget>[
                Text(getDateFormat(post.date), textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
                Image.network(post.imageURL),
                SizedBox(height: 30, width: 30),
                Text("Items: ${post.quantity.toString()}", textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
                SizedBox(height: 10),
                Text("( ${post.latitude} , ${post.longitude} )", textAlign: TextAlign.center, style: TextStyle(fontSize: 20))
              ]
            )
          )
        )
      )
    );
  }
}