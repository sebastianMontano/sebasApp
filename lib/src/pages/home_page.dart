import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_food/src/model/producto_model.dart';
import 'package:tp_food/src/model/usuario_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.usuario}) : super(key: key);
  final String title;
  final UsuarioModel usuario;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            FlatButton(
              child: Text("Salir"),
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
          children: <Widget>[_listaProductos()],
        )),
        floatingActionButton: Stack(
          children: <Widget>[
            _crearProducto(context)],
        ));
  }

  _crearProducto(BuildContext context) {
    if (widget.usuario.rol == "provider") {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.pushNamed(context, 'producto', arguments: widget.usuario),
      );
    } else if(widget.usuario.rol == "customer") {
          return FloatingActionButton(
        child: Icon(Icons.restaurant_menu),
        onPressed: () => Navigator.pushNamed(context, 'alta'),
      );
    }else{
      return null;
    }
  }

  Widget _listaProductos() {
    return StreamBuilder(
        stream: databaseReference.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, int index) {
                    //List rev = snapshot.data.documents.;
                    //Producto _producto = Producto.fromSnapshot(rev[index]);
                    Producto _producto =
                        Producto.fromSnapshot(snapshot.data.documents[index]);
                    //print(_producto.estado);
                    return _buildList(context, _producto);
                  });
          }
        });
  }

  Future<Producto> _load(Producto _producto) async {
    await _producto.loadUser();
    return _producto;
  }

  Widget _buildList(BuildContext context, Producto producto) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: FutureBuilder(
            future: _load(producto),
            builder: (context, AsyncSnapshot<Producto> producto) {
              if (!producto.hasData) return Container();
              return Card(
                child: Column(children: <Widget>[
                  ListTile(
                    onTap: () {
                      //print(document['nombres']);
                    },
                    title: new Text("Menu " + producto.data.user.nombres),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: producto.data.productos.map((element) {
                        return Text(element.descripcion);
                      }).toList(),
                    ),
                    trailing:
                        new Text("Precio " + producto.data.precio.toString()),
                  )
                ]),
              );
            }));
  }
}
