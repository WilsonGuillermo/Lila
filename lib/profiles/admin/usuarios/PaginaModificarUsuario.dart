// Version 1.1.0 WilsonGuillermo
// Agregamos la verification du token
// Maj y supresion cuenta OK

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/servicios/api_servicios_cuentas.dart';
import 'package:tienda/Transverso/dialogos.dart';
import 'package:tienda/Transverso/token_helper.dart';

class EditProfilePage extends StatefulWidget {
  // Recibe el usuario a modificar
  final dynamic usuario;
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
  late int _id_usuario = 0;

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.usuario["nombre"]);
    _lastnameController = TextEditingController(text: widget.usuario["apellido"]);
    _selectedRole = widget.usuario["rol"] ?? "Usuario"; // Si no tiene role pone "Usuario"
    _id_usuario = widget.usuario["id_usuario"];

    print("el rol est : $_selectedRole");
    print("el id est : $_id_usuario");

    fetchRoles().then((roles) {
      setState(() {
        _roles = roles.map((r) =>
        {
          "id": r["id_rol"],
          "nombre": r["nombre_del_rol"],
        }).toList();

        print("Los profiles recuperados son: ${_roles}");
      });
    });
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
        "id": widget.usuario["id_usuario"], // Necesitamos el ID para actualizar
        "nombre": _nameController.text,
        "apellido": _lastnameController.text,
        "rol": _selectedRole,
      };

      print("los datos a poner al dia son : $updatedUser");

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
                    value: role["nombre"], // Extraemos solo el nombre
                    child: Text(role["nombre"]), // Mostramos solo el nombre
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
              ElevatedButton.icon(
                icon: Icon(Icons.delete_forever),
                label: Text("Suprimir Cuenta"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  mostrarDialogoConfirmacion(
                    context: context,
                    mensaje: '¿Seguro que deseas eliminar a ${widget.usuario["nombre"]}?',
                    onDelete: () async {
                      await ApiServiciosCuentas.suprimirUsuario(widget.usuario["id_usuario"]);
                      Navigator.pop(context); // Regresa a la lista después de eliminar
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
