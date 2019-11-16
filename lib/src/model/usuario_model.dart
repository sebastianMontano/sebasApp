import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
    String uid;
    String nombres;
    String email;
    String rol;
    int dni;
    String fechaNac;
    bool estado;

    UsuarioModel({
        this.uid,
        this.nombres= "",
        this.email = "",
        this.rol = "customer",
        this.dni ,
        this.fechaNac,
        this.estado=false,
    });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        uid: json["uid"],
        nombres: json["nombres"],
        email: json["email"],
        rol: json["rol"],
        dni: json["dni"],
        fechaNac: json["fechaNac"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        //"uid": uid,
        "nombres": nombres,
        "email": email,
        "rol": rol,
        "dni": dni,
        "fechaNac": fechaNac,
        "estado": estado,
    };
}