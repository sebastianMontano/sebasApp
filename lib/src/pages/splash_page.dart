import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_food/src/model/usuario_model.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    super.initState();
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {Navigator.pushReplacementNamed(context, "/login")}
              else
                {
                  Firestore.instance
                      .collection("users").document(currentUser.uid).get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        title: result["nombres"] ,
                                        usuario: UsuarioModel.fromJson(result.data),
                                      )
                              )))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}