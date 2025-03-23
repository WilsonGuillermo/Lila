import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tienda/Transverso/parametros.dart';

class ApiServiciosCuentas {
  // Recuperacion parametros backend
  static String url = Parametros.direccionBackend;
  static int puerto = Parametros.puerto;

  // Actualizar usuario
  static Future<bool> modificarUsuario(Map<String, dynamic> user) async {
    final response = await http.put(Uri.parse('$url:$puerto/modificarCuenta/${user['id']}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user),
    );

    return response.statusCode == 200;
  }

  // Eliminar usuario
  static Future<bool> suprimirUsuario(int userId) async {
    final response = await http.delete(Uri.parse("$url:$puerto/suprimirCuenta/$userId"));

    return response.statusCode == 200;
  }

  // Obtener lista de usuarios
  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse("$url:$puerto/users"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}

