// Version 1.1.0 WilsonGuillermo
// Agregamos la verification du token
// Estamos mejorando la version agregando un token de autentificacion para guardar la session del usuario

import 'dart:convert';
import 'package:flutter/material.dart'; //Il s'agit du package Material de Flutter qui nous permettra d'accéder à de nombreux widgets indispensables à nos applications.
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/token_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'La Tienda -- Pagina de Identificacion',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: const Text('Iniciar sesión'),
            ),
            Image.asset(
              'assets/images/cop16-Cali.PNG',
              height: 100,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    // Recuperacion parametros backend
    String url = Parametros.direccionBackend;
    int puerto = Parametros.puerto;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Por favor, complete todos los campos.');
    } else {
      try {
        final response = await http.post(
          Uri.parse('$url:$puerto/auth/login'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'nombre_usuario': username,
            'contrasena': password,
          }),
        );

        print("la requete est: $url:$puerto/login, $username, $password");
        handleResponse(response, context);
      } catch (error) {
        // Manejar errores de connexion u otros
        print('requete enviada 3 con error');
        print('Error: $error');
        _showErrorDialog(context, 'Demarrer le Backend, por favor.');
      }
    }
  }

  Future<void> handleResponse(http.Response response, BuildContext context) async {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      _showSuccessDialog(context);
      // Procesar la respuesta si la solicitud fue exitosa
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      print('Datos del usuario: $responseData');

      await guardarSesion(
            token: responseData['access_token'],
            nombre: responseData['nombre_usuario'],
            rol: responseData['profil'],
      );

      // Recuperamos el perfil del usuario
      Profile perfil =
          Profile(nombre: responseData['nombre_usuario'], rol: responseData['profil']);

        print('El token del usuario: ----2');
      Widget PaginaPerfil;

      print('El token del usuario: ----3');

      if (perfil.rol == 'Admin') {
        Navigator.pushReplacementNamed(context, '/pagina_de_admin',
            arguments: perfil);
      } else if (perfil.rol == 'Cocinero') {
        Navigator.pushReplacementNamed(context, '/pagina_de_cocinero',
            arguments: perfil);
      } else if (perfil.rol == 'Dirigente') {
        Navigator.pushReplacementNamed(context, '/pagina_de_dirigente',
            arguments: perfil);
      } else if (perfil.rol == 'Vendedor') {
        Navigator.pushReplacementNamed(context, '/pagina_de_vendedor',
            arguments: perfil);
      }
    } else {
      // Manejar errores si la solicitud falla
      // Mostrar popup de error de credenciales
      print('Error en la solicitud: ${response.statusCode}');

      _showErrorDialog(
          context, 'Credenciales incorrectas. Por favor, inténtalo de nuevo.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearFields();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exito'),
          content: const Text('¡Inicio de sesión exitoso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearFields();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    _usernameController.clear();
    _passwordController.clear();
  }
}

class Profile {
  final String nombre;
  final String rol;

  Profile({required this.nombre, required this.rol});
}
