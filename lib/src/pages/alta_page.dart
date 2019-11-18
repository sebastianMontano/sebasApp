import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:tp_food/src/model/usuario_model.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

final terminosCondicionesHeader = "TERMINOS Y CONDICIONES";

final terminosCondicionesBody =
    "La continuacion del proceso de afiliación regula\n\n"
    "la relación contractual entre los usuarios con App S.A.C.\n\n"
    "(R.U.C. No: 20602985971) exclusivamente a residentes en\n\n"
    "la República de Perú.Los usuarios se encontrarán sujetos\n\n"
    "a los Términos y Condiciones Generales respectivos,junto\n\n"
    "con todas las demás políticas y principios que rigen App.";

final instruccionesHeader = "INSTRUCCIONES";

final instruccionesBody = "1.Depositar a alguna de las siguientes cuentas:\n\n"
    "BCP:191-2392008-0-95\n\n"
    "Interbank:191-2392008-0-95\n\n"
    "2.Ingresar el nombre del negocio\n\n"
    "3.Ingresar la direccion del negocio\n\n"
    "4.Subir el voucher del deposito o captura de banca movil\n\n"
    "5.Listo! en los proximos dias te avisaremos cuando puedes empezar a publicar\n\n";

var stringBuffer = new StringBuffer();

class AltaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _crearForm(context),
        ],
      ),
    );
  }

  Widget _crearForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[_crearBloqueTexto(), _crearBotones(context)],
    );
  }

  Widget _crearBloqueTexto() {
    stringBuffer.clear();
    stringBuffer.write("\n\n");
    stringBuffer.write(terminosCondicionesHeader + "\n\n");
    stringBuffer.write(terminosCondicionesBody + "\n\n");
    stringBuffer.write("\n\n" + instruccionesHeader + "\n\n");
    stringBuffer.write(instruccionesBody + "\n\n");

    return Container(
      child: Text(stringBuffer.toString(),
          style: TextStyle(color: Colors.white, fontSize: 14.0)),
    );
  }

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

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            child: Text('Continuar'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, "registroProv");
            }),
        RaisedButton(
            child: Text('Regresar'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            }
/*           onPressed: () async {
            FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
             Navigator.pushAndRemoveUntil(
               context,
              new MaterialPageRoute(
                builder: (context) => HomePage(
                            title: currentUser.email,
                            usuario: UsuarioModel.fromJson(result.data),
                          )
              ),
              ModalRoute.withName("home"));
          } */
            )
      ],
    );
  }
}
