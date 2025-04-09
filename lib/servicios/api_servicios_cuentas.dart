// Version 1.1.0 WilsonGuillermo
// Agregamos la verification du token

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/token_helper.dart';

class ApiServiciosCuentas {
  // Recuperacion parametros backend
  static String url = Parametros.direccionBackend;
  static int puerto = Parametros.puerto;

  // Actualizar usuario
  static Future<bool> modificarUsuario(Map<String, dynamic> user) async {
    final headers = await getHeadersConToken();

    print("los datos al dia son...........: $user");
    print("el id est: ${user['id']}");
    print("el nombre est: ${user['nombre']}");
    print("el apellido est: ${user['apellido']}");


    final response = await http.put(
      Uri.parse('$url:$puerto/usuarios/${user['id']}'),
      headers: headers,
      body: jsonEncode(user),
    );

    return response.statusCode == 200;
  }

  // Eliminar usuario
  static Future<bool> suprimirUsuario(int userId) async {
    final headers = await getHeadersConToken();

    print("usuario a suprimer : ${userId}");

    final response = await http.delete(Uri.parse('$url:$puerto/usuarios/$userId'),
        headers: headers
    );

    return response.statusCode == 200;
  }

  // Obtener lista de usuarios
  static Future<List<dynamic>> getUsers() async {
    final headers = await getHeadersConToken();

    final response = await http.get(Uri.parse('$url:$puerto/auth/usuarios'),
        headers: headers
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}

