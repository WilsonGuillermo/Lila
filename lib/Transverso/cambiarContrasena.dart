// Version 1.0.0 WilsonGuillermo
// Introducimos la obligacion de cambiar la contrasena cuando el usuario se conecta por primera vez
// ELe damos la opcion al usuario de cambiar la contrasena cuando sea necesario

import 'dart:convert';
import 'package:flutter/material.dart'; //Il s'agit du package Material de Flutter qui nous permettra d'accéder à de nombreux widgets indispensables à nos applications.
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/token_helper.dart';
import 'package:tienda/Transverso/identificacion.dart';

class CambiarContrasenaPage extends StatefulWidget {
  final int id_usuario;
  final bool primerAcceso;

  const CambiarContrasenaPage({
    Key? key,
    required this.id_usuario,
    this.primerAcceso = false,
  }) : super(key: key);

  @override
  _CambiarContrasenaPageState createState() => _CambiarContrasenaPageState();
}

class _CambiarContrasenaPageState extends State<CambiarContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _obscureText = true;
  bool _guardando = false;

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  void _guardarNuevaContrasena() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    final nuevaContrasena = _contrasenaController.text;

    final prefs = await SharedPreferences.getInstance();

    print("el mdp a enviar es : $nuevaContrasena");
    //String password = _passwordController.text;
    final headers = await getHeadersConToken();

    final response = await http.put(
      // Requete que envia todo en el url
      //Uri.parse('$url:$puerto/usuarios/${widget.id_usuario}/cambiar_contrasena?nueva_contrasena=$password'),
      // Requete que envia parametros en el body
      Uri.parse('$url:$puerto/usuarios/${widget.id_usuario}/cambiar_contrasena'),
      //Uri.parse('$url:$puerto/usuarios/${id_usuario}/cambiar_contrasena'),
      headers: headers,
      body: jsonEncode({
        'contrasena': nuevaContrasena,
      }),
    );

    setState(() {
      _guardando = false;
    });

    if (response.statusCode == 200) {
      if (widget.primerAcceso) {
        //Navigator.pushReplacementNamed(context, 'LoginPage()'); // o la que sea
        prefs.setBool('primerAcceso', false); // Actualiza localmente también
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar la contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Contraseña'),
        automaticallyImplyLeading: !widget.primerAcceso,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.primerAcceso)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Por seguridad, debes cambiar tu contraseña antes de continuar.',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              TextFormField(
                controller: _contrasenaController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Nueva Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña no puede estar vacía';
                  }
                  final regex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
                  if (!regex.hasMatch(value)) {
                    return 'Debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!widget.primerAcceso)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed:
                    _guardando ? null : () => _guardarNuevaContrasena(),
                    child: const Text('Guardar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}