//Archivo: dialogos.dart (completo y limpio)
// Version 1.0.0 WilsonGuillermo

import 'dart:convert';
import 'package:flutter/material.dart'; //Il s'agit du package Material de Flutter qui nous permettra d'accéder à de nombreux widgets indispensables à nos applications.
import 'package:http/http.dart' as http;

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/servicios/api_servicios_cuentas.dart';
import 'package:tienda/Transverso/dialogos.dart';
import 'package:tienda/Transverso/token_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> mostrarDialogoConfirmacion({
  required BuildContext context,
  required String mensaje,
  required VoidCallback onDelete,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Confirmación'),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Cierra primero
              onDelete(); // Luego ejecuta
            },
          ),
        ],
      );
    },
  );
}

Future<List<String>> fetchRoles() async {
  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  final headers = await getHeadersConToken();

  final response = await http.get(Uri.parse('$url:$puerto/auth/roles'),
      headers: headers
  );

  if (response.statusCode == 200) {
    final List<dynamic> roles = json.decode(response.body);
    return roles.map<String>((r) => r['nombre_del_rol'].toString()).toList();
  } else {
    throw Exception('Error al cargar los roles');
  }
}

