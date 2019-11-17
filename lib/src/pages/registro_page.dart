import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_food/src/model/usuario_model.dart';
import 'package:tp_food/src/utils/utils.dart' as utils;
import 'package:intl/intl.dart';
import 'home_page.dart';

class RegistroPage extends StatefulWidget {
  RegistroPage({Key key}) : super(key: key);

  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage>{

 final formkey = GlobalKey<FormState>();
 UsuarioModel usuario = new UsuarioModel();
 TextEditingController pwdInputController = new TextEditingController();
 final format = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _registroForm(context),
        ],
      )
    );
  }

  Widget _registroForm(BuildContext context){

    final size = MediaQuery.of(context).size;

     return SingleChildScrollView(
       child: Column(
         children: <Widget>[
           SafeArea(
             child: Container(
               height: 50.0,
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
             child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    Text('Registro' , style : TextStyle(fontSize: 20.0)),
                    SizedBox(height: 60.0),
                    _crearInputNombres(),
                    _crearInputEmail(),
                    _crearInputPassword(),
                    _crearInputDNI(),
                    _crearInputFechaNacimiento(),
                    SizedBox(height: 30.0),
                    _crearBoton(context)
                  ],
              ),
             )           
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

  Widget _crearInputNombres(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        initialValue: usuario.nombres,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.text_fields,color:Colors.deepPurpleAccent),
          labelText: 'Nombre Completo',
        ),
        onSaved: (value) => usuario.nombres = value,         
      ),
    );

  }

  Widget _crearInputEmail(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        initialValue: usuario.email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.alternate_email,color:Colors.deepPurpleAccent),
          hintText: 'ejemplo@correo.com',
          labelText: 'Correo electronico',
        ),
        onSaved: (value)=> usuario.email = value,
        validator: (value) {
            if (utils.validarCorreo(value)){
              return null;
            }else{
              return 'Email no es correcto';
            }
        },
      ),
    );
  }

  Widget _crearInputPassword(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline,color:Colors.deepPurpleAccent),
          labelText: 'Contraseña',
        ),
        controller: pwdInputController,
        validator: (value){
          if(value.length >=6){
            return null;
          }else{
            return 'Más de 6 caracteres';
          }
        },
      ),
    );
  }

  Widget _crearInputDNI(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(

        keyboardType: TextInputType.number,
        maxLength: 8,
        decoration: InputDecoration(
          icon: Icon(Icons.note,color:Colors.deepPurpleAccent),
          labelText: 'Documento de Identidad',
        ),
        onSaved: (value)=> usuario.dni = int.tryParse(value),
        validator: (value){
          if(utils.isNumeric(value)){
            return null;
          }else{
            return 'Solo Números';
          }
        },
      ),
    );
  }

  Widget _crearInputFechaNacimiento(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DateTimeField(
        format: format,
        decoration: InputDecoration(
          icon: Icon(Icons.note,color:Colors.deepPurpleAccent),
          labelText: 'Fecha Nacimiento',
        ),
        onSaved: (value)=> usuario.fechaNac = value.toString(),
        validator: (date){
          final date2 = DateTime.now();
          //print(date2.difference(date).inDays);
          final year = (date2.difference(date).inDays/365).floor();
          //print(year);

          if( year >= 18){
            return null;
          }else{
            return "Debe ser Mayor de Edad";
          }
        },
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    );
  }

  Widget _crearBoton(BuildContext context){

        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Registrar'),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed:  _registro,
        ); 
  }

  Widget _crearFondo(BuildContext context){

    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height,
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
        fondoMorado
      ],
    );
  }

  _registro() {

     if(!formkey.currentState.validate()) return null;

     formkey.currentState.save();

     FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: usuario.email,
      password: pwdInputController.text)
      .then((currentUser) => Firestore.instance
        .collection("users")
        .document(currentUser.user.uid)
        .setData({
          "uid": currentUser.user.uid,
          "nombres": usuario.nombres,
          "email": usuario.email,
          "rol": usuario.rol,
          "dni": usuario.dni,
          "fechaNac": usuario.fechaNac,
        }).then((result) => {
          Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(
                          title: "Lista Productos",
                          usuario: usuario
                        )),
                (_) => false)
        }).catchError((err) => utils.mostrarAlerta(context,err.message)))
      .catchError((err) => utils.mostrarAlerta(context,err.message));
  }
  
}