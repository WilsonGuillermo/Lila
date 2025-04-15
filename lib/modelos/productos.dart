// Version 1.0.0 WilsonGuillermo

import 'package:flutter/material.dart';

class AtributoProducto {
  String nombre;
  String valor;

  AtributoProducto({required this.nombre, required this.valor});

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'valor': valor,
  };
}

class ProductoVariacion {
  String descripcion;
  int stock;
  double precio;
  List<AtributoProducto> atributos;

  ProductoVariacion({required this.descripcion, required this.stock, required this.precio, required this.atributos});

  Map<String, dynamic> toJson() => {
    'descripcion': descripcion,
    'stock': stock,
    'precio': precio,
    'atributos': atributos.map((e) => e.toJson()).toList(),
  };
}

class ProductoCombo {
  String nombre;
  String descripcion;
  int tipoTiendaId;
  bool activo;
  List<ProductoVariacion> variaciones;

  ProductoCombo({
    required this.nombre,
    required this.descripcion,
    required this.tipoTiendaId,
    this.activo = true,
    required this.variaciones,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'tipo_tienda_id': tipoTiendaId,
    'activo': activo,
    //'variaciones': variaciones.map((e) => e.toJson()).toList(),
    'variaciones': variaciones.map((v) => {
      'descripcion': v.descripcion,
      'precio': v.precio,
      'stock': v.stock,
      'atributos': v.atributos
          .map((a) => {'nombre': a.nombre, 'valor': a.valor})
          .toList(),
    }).toList(),
  };
}
