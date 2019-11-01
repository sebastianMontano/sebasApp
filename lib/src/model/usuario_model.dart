import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
    int uid;
    String nombres;
    String email;
    int dni;
    String fechaNac;
    bool estado;

    UsuarioModel({
        this.uid,
        this.nombres,
        this.email,
        this.dni,
        this.fechaNac,
        this.estado,
    });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        uid: json["uid"],
        nombres: json["nombres"],
        email: json["email"],
        dni: json["dni"],
        fechaNac: json["fechaNac"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "nombres": nombres,
        "email": email,
        "dni": dni,
        "fechaNac": fechaNac,
        "estado": estado,
    };
}