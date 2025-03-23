import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String? size;
  final String? color;
  final int stock;
  final String? imagen; // campo para el URL de la imagen que puede ser nulo
  final String tipo;
  final String referencia;
  final String estilo;
  final String corte;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.size,
    this.color,
    required this.stock,
    this.imagen, // marcar como opcional
    required this.tipo,
    required this.referencia,
    required this.estilo,
    required this.corte,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    //print("---estoy aqui-------");
    return Product(
      id: json['id'] as int,
      name: json['name'],
      description: json['description'],
      //price: double.parse(json['price']),
      price: double.parse(json['price'] as String),
      categoryId: json['categoryId'] as int,
      size: json['size'] as String?,
      color: json['color'] as String?,
      stock: json['stock'] as int,
      imagen: json['imagen'] as String?, // Asignar directamente y puede ser nulo
      tipo: json['tipo'] as String,
      referencia: json['referencia'] as String,
      estilo: json['estilo'] as String,
      corte: json['corte'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    //print("---estoy aqui bis-------");
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'size': size,
      'color': color,
      'stock': stock,
      'imagen': imagen, // Asignar directamente y puede ser nulo
      'tipo': tipo,
      'referencia': referencia,
      'estilo': estilo,
      'corte': corte,
    };
  }
}