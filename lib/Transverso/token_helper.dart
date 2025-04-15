//Archivo: token_helper.dart (completo y limpio)

import 'dart:convert';
import 'package:flutter/material.dart'; //Il s'agit du package Material de Flutter qui nous permettra d'accéder à de nombreux widgets indispensables à nos applications.
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda el token y los datos del usuario
Future<void> guardarSesion({
  required int idUsuario,
  required String token,
  required String nombre,
  required String rol,
  required bool primerAcceso,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('idUsuario', idUsuario);
  await prefs.setString('token', token);
  await prefs.setString('nombre', nombre);
  await prefs.setString('rol', rol);
  await prefs.setBool('primerAcceso', primerAcceso);
}

/// Recupera el token JWT
Future<String?> recuperarToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

/// Recupera datos del usuario como un mapa
Future<Map<String, dynamic?>> recuperarDatosUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'idUsuario': prefs.getInt('idUsuario'),
    'nombre': prefs.getString('nombre'),
    'rol': prefs.getString('rol'),
    'primerAcceso': prefs.getBool('primerAcceso') ?? false,
  };
}

/// Borra la sesión del usuario (logout)
Future<void> borrarSesion() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('nombre');
  await prefs.remove('rol');
  await prefs.remove('primerAcceso');
}

/// Headers para peticiones autenticadas
Future<Map<String, String>> getHeadersConToken() async {
  final token = await recuperarToken();
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
