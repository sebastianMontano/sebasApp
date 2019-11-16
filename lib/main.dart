import 'package:flutter/material.dart';
import 'package:tp_food/src/bloc/provider.dart';
import 'package:tp_food/src/pages/admin_page.dart';
import 'package:tp_food/src/pages/home_page.dart';
import 'package:tp_food/src/pages/login_page.dart';
import 'package:tp_food/src/pages/product_page.dart';
import 'package:tp_food/src/pages/registro_page.dart';
import 'package:tp_food/src/preferencias_usuario/preferencia_usuario.dart';
 
void main()  async {

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();

    print(prefs.token);

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context ) => LoginPage(),
          'home': (BuildContext context ) => HomePage(),
          'registro': (BuildContext context ) => RegistroPage(),
          'producto': (BuildContext context ) => ProductoPage(),
          'administrador' : (BuildContext context ) => AdminPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
    
    
    
  }
}