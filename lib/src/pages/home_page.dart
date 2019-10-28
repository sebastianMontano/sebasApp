import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title, this.uid}) : super(key: key); 
  //update the constructor to include the uid
  final String title;
  final String uid; //include this


  @override
  _HomePageState  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                      Navigator.pushReplacementNamed(context, "login"))
                  .catchError((err) => print(err));
            },
          )
        ],
      )
    );
  }

}