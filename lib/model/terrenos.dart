import 'package:flutter/material.dart';

class ObjetoTerreno{

  String terrain;
  String crop;
  String creation_stamp;
  String status;
  String texto_status;

  ObjetoTerreno({
    required this.terrain,
    required this.crop,
    required this.creation_stamp,
    required this.status,
    required this.texto_status,
  });

  Map<String, dynamic> to_Map() => {
    "terrain": terrain,
    "crop": crop,
    "creation_stamp": creation_stamp,
    "status": status,
    "texto_status": texto_status,
  };


  factory ObjetoTerreno.fromJson(Map<String, dynamic> json) {
    return  ObjetoTerreno(
      terrain: json['terrain'] == null? '':  json['terrain'],
      crop: json['crop'] == null? '':  json['crop'],
      creation_stamp: json['creation_stamp'] == null? '':  json['creation_stamp'],
      status: json['status'] == null? '': json['status'],
      texto_status: "",
    );
  }

}
