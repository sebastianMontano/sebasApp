import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductoPage extends StatelessWidget {

  const ProductoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Producto"),
        
      ),
      
      body: Text("Hola"),
    );
  }
}