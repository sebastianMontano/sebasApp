
import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context,String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Informacion Incorrecta'),
        content:Text(mensaje),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: ()=> Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}

bool validarCorreo(String email){
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern);

        if(regExp.hasMatch(email)){
          return true;
        }else{
          return false;
        }
}

bool isNumeric(String valor){
   if ( valor.isEmpty) return false;

   final n = num.tryParse(valor);

   return (n == null) ? false : true;
}