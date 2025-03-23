import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/servicios/api_servicios_cuentas.dart';

class EditProfilePage extends StatefulWidget {
  //final UserModel user; // Recibe el usuario a modificar
  final dynamic usuario;
  //List<dynamic> _usuariosFiltrados = [];

  //EditProfilePage({required this.usuario, Key? key}) : super(key: key);
  EditProfilePage({required this.usuario});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _roles = [];
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late String _selectedRole;

  //final dynamic usuario_a_modifier = usuario;
  //print('el usuario a modificar es: 'usuario_a_modifier);

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.usuario["name"]);
    _lastnameController = TextEditingController(text: widget.usuario["lastname"]);
    _selectedRole = widget.usuario["rol"] ?? "Usuario"; // Si no tiene role pone "Usuario"
    print("el rol est : $_selectedRole");

    Future.microtask(() => _fetchRoles()); // Cargamos los roles
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  void _updateUsuario() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = {
        "id": widget.usuario["id"], // Necesitamos el ID para actualizar
        "name": _nameController.text,
        "lastname": _lastnameController.text,
        "role": _selectedRole,
      };

      bool success = await ApiServiciosCuentas.modificarUsuario(updatedUser);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario actualizado correctamente")),
        );
        Navigator.pop(context, true); // Retorna "true" para indicar que hubo cambios
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar usuario")),
        );
      }
    }
  }

  void _deleteUsuario(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar usuario"),
        content: Text("¿Seguro que quieres eliminar a ${user["name"]}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              bool success = await ApiServiciosCuentas.suprimirUsuario(user["id"]);
              print("usuario suprimé $success");

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Usuario eliminado")),
                );
                Navigator.pop(context, true); //Devolvemos "True" al cerrar la pagina
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error al eliminar usuario")),
                );
              }

              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modificar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedRole.isNotEmpty ? _selectedRole: null, // Evitar el Null
                items: _roles.map<DropdownMenuItem<String>> ((role) {
                  return DropdownMenuItem<String>(
                    value: role["role"], // Extraemos solo el nombre
                    child: Text(role["role"]), // Mostramos solo el nombre
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: "Rol"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUsuario,
                child: const Text("Guardar Cambios"),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                //onPressed: () => Navigator.pop(context),
                onPressed: () => _deleteUsuario(widget.usuario),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Eliminar Cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//void main() {
//  runApp(MaterialApp(
//    home: EditProfilePage(),
//  ));
//}