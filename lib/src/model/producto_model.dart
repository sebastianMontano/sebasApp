import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_food/src/model/usuario_model.dart';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
    double precio;
    List<ProductoElement> productos;
    bool estado;
    String provider;
    UsuarioModel user;
    Producto({
        this.precio=0.0,
        this.productos,
        this.estado=true,
        this.provider=''
    });

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        precio: json["precio"].toDouble(),
        productos: List<ProductoElement>.from(json["productos"].map((x) => ProductoElement.fromJson(x))),
        estado: json["estado"],
        provider: json["provider"],
    );

    Producto.fromSnapshot(DocumentSnapshot snapshot){
        this.precio = snapshot.data["precio"].toDouble();
        this.productos = _parseData(snapshot);
        this.estado = snapshot.data["estado"];
        this.provider = snapshot.data["provider"];
    }

    List<ProductoElement> _parseData(DocumentSnapshot dataSnapshot) {
      List<ProductoElement> productList = new List();
        dataSnapshot.data['productos'].forEach((valor){
              ProductoElement product =  ProductoElement(descripcion: valor['descripcion']);
              productList.add(product);
      });
      return productList;
    }

    Map<String, dynamic> toJson() => {
        "precio": precio,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "estado": estado,
        "provider" :provider
    };

    Future<void> loadUser() async {
      DocumentSnapshot ds = await Firestore.instance
          .collection("users").document(this.provider).get();
      if (ds != null)
        this.user = UsuarioModel.fromSnapshot(ds);
    }
}

class ProductoElement {
    String descripcion;

    ProductoElement({
        this.descripcion='',
    });

    factory ProductoElement.fromJson(Map<String, dynamic> json) => ProductoElement(
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
    };
}