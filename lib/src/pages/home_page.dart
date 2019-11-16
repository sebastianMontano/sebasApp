import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_food/src/model/usuario_model.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title, this.usuario}) : super(key: key); 
  final String title;
  final UsuarioModel usuario; 

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
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Hola ${widget.usuario.rol}"),
          ],
        )
      ),
      floatingActionButton: _crearProducto(context),
    );
  }

  _crearProducto(BuildContext context){
    if(widget.usuario.rol == "provider"){
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'producto'),
      );
    }else{
      return null;
    }     
  }

}