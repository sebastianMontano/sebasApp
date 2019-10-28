import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tp_food/src/preferencias_usuario/preferencia_usuario.dart';

class UsuarioProvider{

  final _apikey = 'AIzaSyDma86BEsJTs67uhKofYeZtTq86K9D-S2U';
  final _prefsUsuario = PreferenciasUsuario();

  Future<Map<String,dynamic>> nuevoUsuario(String email,String password) async{
    
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apikey',
      body: json.encode(authData));

      Map<String,dynamic> decodeResp = json.decode(resp.body);

      print(decodeResp);

      if(decodeResp.containsKey('idToken')){
        // Salvar el token en el storage
        saveToken(decodeResp);
        return {'ok':true,'token':decodeResp['idToken']};
      }else{
        return {'ok':false,'token':decodeResp['error']['message']};
      }
        
    }

  Future<Map<String,dynamic>> login(String email,String password) async{
     final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apikey',
      body: json.encode(authData));

      Map<String,dynamic> decodeResp = json.decode(resp.body);

      print(decodeResp);

      if(decodeResp.containsKey('idToken')){
        // Salvar el token en el storage
        saveToken(decodeResp);
        return {'ok':true,'token':decodeResp['idToken']};
      }else{
        return {'ok':false,'mensaje':decodeResp['error']['message']};
      }
  }

  void saveToken(Map<String,dynamic> decodeResp){
    _prefsUsuario.token = decodeResp['idToken'];
  }
}