//Archivo: token_helper.dart (completo y limpio)

import 'dart:convert';
import 'package:flutter/material.dart'; //Il s'agit du package Material de Flutter qui nous permettra d'accéder à de nombreux widgets indispensables à nos applications.
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda el token y los datos del usuario
Future<void> guardarSesion({
  required String token,
  required String nombre,
  required String rol,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
  await prefs.setString('usuario_nombre', nombre);
  //await prefs.setInt('usuario_rol_id', rol_id);
  await prefs.setString('usuario_rol', rol);
}

/// Recupera el token JWT
Future<String?> recuperarToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

/// Recupera datos del usuario como un mapa
Future<Map<String, String?>> recuperarDatosUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'nombre': prefs.getString('usuario_nombre'),
    'email': prefs.getString('usuario_email'),
    //'rol_id': prefs.getString('usuario_rol_id'),
    'rol': prefs.getString('usuario_rol'),
  };
}

/// Borra la sesión del usuario (logout)
Future<void> borrarSesion() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
  await prefs.remove('usuario_nombre');
  await prefs.remove('usuario_email');
  await prefs.remove('usuario_rol');
}

/// Headers para peticiones autenticadas
Future<Map<String, String>> getHeadersConToken() async {
  final token = await recuperarToken();
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
