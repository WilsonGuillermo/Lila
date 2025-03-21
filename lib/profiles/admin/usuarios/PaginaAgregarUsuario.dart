import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tienda/Transverso/parametros.dart';

class PaginaAgregarUsuario extends StatefulWidget {
  @override
  _PaginaAgregarUsuarioState createState() => _PaginaAgregarUsuarioState();
}

class _PaginaAgregarUsuarioState extends State<PaginaAgregarUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedDate;
  List<dynamic> _roles = [];
  dynamic _selectedRole;
  //String? _selectedProfile;

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    final response = await http.get(Uri.parse('$url:$puerto/roles'));

    print('los roles');
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _roles = jsonDecode(response.body);
      });
    } else {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los roles')),
      );
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return false;
    return true;
  }

  Future<bool> isLoginAvailable(String login) async {
    final response = await http.get(Uri.parse('$url:$puerto/verificarCuenta/$login'));
    return response.statusCode == 200;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final loginAvailable = await isLoginAvailable(_loginController.text);
      if (!loginAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El login ya existe')),
        );
        return;
      }

      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione un perfil')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('$url:$puerto/agregarCuenta'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': _nameController.text,
          'surname': _surnameController.text,
          'login': _loginController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'birth_date': _selectedDate.toString(),
          'role': _selectedRole['role'].toString(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en la creación del usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Utiliza el atributo flexibleSpace para definir el fondo de gradiente
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.green,
              ],
            ),
          ),
        ),
        leading: const Icon(Icons.account_circle_rounded),
        leadingWidth: 100, // default is 56
        elevation: 10.0,

        title: const Text(
          'La Tienda -- Pagina Creacion de Usuarios',

          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            //backgroundColor: Color.fromARGB(255, 11, 101, 161),
          ),
        ),
        actions: [
          // Ejemplo de un ícono de búsqueda
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Acción al presionar el ícono de búsqueda
            },
          ),
          // Ejemplo de un ícono de configuración
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Acción al presionar el ícono de configuración
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 11, 101, 161),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su login';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su email';
                  } else if (!isValidEmail(value)) {
                    return 'Por favor ingrese un email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  } else if (!isValidPassword(value)) {
                    return 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirmar Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su contraseña';
                  } else if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<dynamic>(
                items: _roles.map<DropdownMenuItem<dynamic>>((role) {
                  return DropdownMenuItem<dynamic>(
                    value: role,
                    child: Text(role['role']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Perfil'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un perfil';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_selectedDate == null ? 'Seleccione su fecha de nacimiento' : 'Fecha de nacimiento: ${_selectedDate.toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height:20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar'),
              ),
              const SizedBox(height:10),
              TextButton(
                onPressed: () {
                  // Regresamos al menu Admin
                  Navigator.pop(context);
                },
                child: const Text('Regreso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaginaAgregarUsuario(),
  ));
}