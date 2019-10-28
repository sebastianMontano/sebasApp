import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_food/src/bloc/provider.dart';
import 'package:tp_food/src/providers/usuario_provider.dart';
import 'package:tp_food/src/utils/utils.dart';

import 'home_page.dart';

class RegistroPage extends StatelessWidget {

 final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context){

    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);

     return SingleChildScrollView(
       child: Column(
         children: <Widget>[

           SafeArea(
             child: Container(
               height: 200.0,
             ),
           ),

           Container(
             width: size.width * 0.85,
             margin: EdgeInsets.symmetric(vertical: 30.0),
             padding: EdgeInsets.symmetric(vertical: 50.0),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(5.0),
               boxShadow: <BoxShadow>[
                 BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0)
               ]
             ),
             child: Column(
               children: <Widget>[
                 Text('Registro' , style : TextStyle(fontSize: 20.0)),
                 SizedBox(height: 60.0),
                 _crearEmail(bloc),
                 SizedBox(height: 30.0),
                 _crearPassword(bloc),
                 SizedBox(height: 30.0),
                 _crearBoton(bloc)
               ],
             ),
           ),

           FlatButton(
             child: Text('Ya tienes cuenta?'),
             onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
           ),
           SizedBox(height: 100.0)
         ],
       ),
     );
  }

  Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email,color:Colors.deepPurpleAccent),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electronico',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );  
  }

  Widget _crearPassword(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline,color:Colors.deepPurpleAccent),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
    
  }

  Widget _crearBoton(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Registrar'),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? ()=> _registro(bloc,context) : null,
        );
      },
    );
    
  }

  Widget _crearFondo(BuildContext context){

    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height*0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Container(
          padding: EdgeInsets.only(top:80.0),
          child: Column(
            children: <Widget>[
                Icon(Icons.person_pin_circle,color:Colors.white,size: 100.0),
                SizedBox(height: 10.0,width: double.infinity),
                Text('App Customer', style: TextStyle(color: Colors.white,fontSize: 25.0))
            ],
          ),
        )

      ],
    );
  }

  _registro(LoginBloc bloc,BuildContext context) {
      //final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);
      FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: bloc.email,
      password: bloc.password)
      .then((currentUser) => Firestore.instance
        .collection("users")
        .document(currentUser.user.uid)
        .setData({
          "uid": currentUser.user.uid,
          "email": currentUser.user.email,
        }).then((result) => {
          Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          title: currentUser.user.email +  "'s App",
                          uid: currentUser.user.uid,
                        )),
                (_) => false)
        }).catchError((err) => print(err)))
      .catchError((err) => print(err));
    /*if(info['ok']){
    }else{
      mostrarAlerta(context,info['mensaje']);
    }*/
  }
}