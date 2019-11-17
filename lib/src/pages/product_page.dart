import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp_food/src/model/producto_model.dart';
import 'package:tp_food/src/model/usuario_model.dart';
import 'package:tp_food/src/utils/utils.dart' as utils;

class ProductoPage extends StatelessWidget {

  const ProductoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final UsuarioModel usuario = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Publicar Producto"),      
      ),
      body: ListaProductos(uid: usuario.uid),
    );
  }
}

class ListaProductos extends StatefulWidget {

  ListaProductos({Key key,this.uid}) : super(key: key);
  final String uid;

  @override
  _ListaProductosState createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  bool _validatePrice = false;
  Producto producto = new Producto();
  FocusNode _focusDescription;

  @override
  void initState() {
    super.initState();
    producto.productos = [];
    _focusDescription = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController?.dispose();
    _precioController?.dispose();
    _focusDescription?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: <Widget>[
           Wrap(
              direction: Axis.horizontal,
              spacing: 20.0,
              children: <Widget>[
                Text(
                  "Ingrese Precio"
                ),
                SizedBox(
                  width: 100.0,
                  child: TextFormField(
                    onChanged: (value){
                      producto.precio = double.parse(value);
                    },
                    decoration: InputDecoration(
                      errorText: _validatePrice ? 'Digite un Precio' : null,
                    ),
                    controller: _precioController,
                    //initialValue: producto.precio.toString(),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                )  
              ],
            ),
            SizedBox(height: 20.0),
            Wrap(
              direction: Axis.horizontal,
              spacing: 20.0,
              children: <Widget>[
                SizedBox(
                  width: 200.0,
                  child:  TextFormField(
                    focusNode: _focusDescription,
                    controller: _descriptionController,
                    decoration: InputDecoration(hintText: "Agrege Producto" ),
                    ),
                ), 
                RaisedButton(
                  onPressed: (){
                    setState(() {
                      producto.productos.add(ProductoElement(descripcion : _descriptionController.text));
                      _descriptionController.clear();
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),  
            SizedBox(height: 20.0),       
            Expanded(
              flex: 0,
              child: Products(producto.productos),
            ),
            SizedBox(height: 30.0),
            RaisedButton(
              child: Text("Empezar a Vender"),
              onPressed: _agregarProducto,
              color: Colors.greenAccent,
            )
       ],),
    );
  }

  void _agregarProducto() {
      if(validateForm()){
        producto.provider = widget.uid;
        _precioController.clear();
        nuevoProducto();
        producto.productos.clear();
      }     
  }

    void nuevoProducto() async{
      final respuesta = await Firestore.instance.collection("products").add(producto.toJson());
      respuesta.get().then((value)=> print(value));
    }

  bool validateForm(){
    setState(() {
       _precioController.text.isEmpty ? _validatePrice = true : _validatePrice =false;
    });
    if(_validatePrice) return false;
    if(producto.productos.isEmpty){
        utils.mostrarAlerta(context,"Debe agregar un Producto");
        _focusDescription.unfocus();
        return false;
    }else{
        return true;
    }
  }
}

class Products extends StatelessWidget {

  final List<ProductoElement> products;
  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction){
          products.removeAt(index);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
        child: ListTile(
          title: Text(products[index].descripcion),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: _buildProductItem,
      itemCount: products.length,
    );
  }
}