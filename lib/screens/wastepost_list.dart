import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/camera_access_button.dart';
import './wastepost_detail.dart';
import '../models/wastepost.dart';

class WastePostList extends StatefulWidget {

  static final routeName = "/";

  @override 
  _WastePostList createState() => _WastePostList();

}

class _WastePostList extends State<WastePostList> {

  String getDateFormat(DateTime date){
    List<String> weekdays = [ "Monday", "Tuesday", "Wednesday", "Thursday", 
                            "Friday", "Saturday", "Sunday" ];
                            
    List<String> months = [ "Jan.", "Feb.", "Mar.", "Apr.", 
                          "May", "Jun.", "Jul.", "Aug.", 
                          "Sep.", "Oct.", "Nov.", "Dec." ];
                          
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  } 
  
  @override
  Widget build(BuildContext context){
    return (
      StreamBuilder(
        stream: Firestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
        builder: (content, snapshot) {
          if (snapshot.hasData && snapshot.data.documents != null && snapshot.data.documents.length > 0){
            return Scaffold(
              appBar: AppBar(
              title: Text("Wastegram ${calculateTotal(snapshot.data.documents)}")
              ),
              body: Column(
              children: [Expanded(child: 
                ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data.documents[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(getDateFormat(post['date'].toDate()), style: TextStyle(fontSize: 30)),
                      trailing: CircleAvatar( 
                        backgroundColor: Colors.white,
                        child: Text(post['quantity'].toString(), style: TextStyle(color: Colors.black))
                      ),
                      onTap: () {
                        var postToShow = WastePost(
                          date: post['date'].toDate(),
                          imageURL: post['imageURL'],
                          latitude: post['latitude'],
                          longitude: post['longitude'],
                          quantity: post['quantity']
                        );
                        Navigator.of(context).pushNamed(WastePostDetail.routeName, arguments: postToShow);
                      }
                    );
                  },
                  ),
                ),
                CameraAccessButton()
              ]
            )
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Wastegram")
              ),
              body: Center(child: Column(children: [SizedBox(height: 200), CircularProgressIndicator(), SizedBox(height:300), CameraAccessButton()])));
            }
        },)
      );
  }

  int calculateTotal(exampleList){
    int sum = 0;
    for (var index in exampleList){
      sum = sum + index['quantity'];
    }
    return sum;
  }
}