import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp_food/src/model/usuario_model.dart';
import 'package:tp_food/src/utils/utils.dart' as utils;

File _imageFile;
FirebaseUser currentUser;

class RegistroProvPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _registroFormProv(context),
        ],
      ),
    );
  }

  static final formkey = GlobalKey<FormState>();
  UsuarioModel usuario = new UsuarioModel();

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0),
      ])),
    );

    return Stack(
      children: <Widget>[fondoMorado],
    );
  }

  Widget _registroFormProv(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _getUser();

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
                  ]),
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    Text('Registro de Proveedor',
                        style: TextStyle(fontSize: 20.0)),
                    SizedBox(height: 60.0),
                    _crearInputNombres(),
                    _crearInputEmail(),
                    _crearBotonUploadImage(),
                    _mostrarimagen(),
                    _crearBoton(context)
                  ],
                ),
              )),
          FlatButton(
            child: Text('Regresar'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'alta'),
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Future _getUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  Widget _crearInputNombres() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.text_fields, color: Colors.deepPurpleAccent),
          labelText: 'Nombre del Negocio',
        ),
        onSaved: (value) => usuario.nombres = value,
      ),
    );
  }

  Widget _crearInputEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.alternate_email, color: Colors.deepPurpleAccent),
          labelText: 'Dirección del Negocio',
        ),
        onSaved: (value) => usuario.email = value,
        validator: (value) {
          if (utils.validarCorreo(value)) {
            return null;
          } else {
            return 'Email no es correcto';
          }
        },
      ),
    );
  }

  Widget _crearBotonUploadImage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: RaisedButton(
        child: Text('Subir voucher'),
        onPressed: () {
          _ImageCaptureState()._pickImage(ImageSource.gallery);
        },
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Registrar'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () {
        _UploaderState().startUpload();
      },
    );
  }

  _mostrarimagen() {
    if (_imageFile == null) {
      return Text("Imagen no seleccionada");
    } else {
      return Image.file(_imageFile);
    }
  }
}

class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    // setState(() {
    _imageFile = selected;
    return Image.file(_imageFile);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Image.file(_imageFile),
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);
  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://tallerdeproyectos1-d6870.appspot.com');
  StorageUploadTask _uploadTask;

  void startUpload() {
    String filePath = 'vouchers/${currentUser.uid}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
  }

  @override
  Widget build(BuildContext context) {}
}
