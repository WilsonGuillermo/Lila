// Version 1.1.0 WilsonGuillermo
// Agregamos la verification du token
// Maj y supresion cuenta OK

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/dialogos.dart';
import 'package:tienda/servicios/api_servicios_cuentas.dart';
import 'package:tienda/profiles/admin/usuarios/PaginaModificarUsuario.dart';
import 'package:tienda/Transverso/token_helper.dart';

class PaginaListarProducto extends StatefulWidget {
  @override
  _PaginaListarProductoState createState() => _PaginaListarProductoState();
}

class _PaginaListarProductoState extends State<PaginaListarProducto> {
  List<dynamic> _usuarios = [];
  List<dynamic> _usuariosFiltrados = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  @override
  void initState() {
    super.initState();
    _loadUsuarios(); // Cargar los usuarios al iniciar
  }

  Future<void> _loadUsuarios() async {
    final headers = await getHeadersConToken();

    final response = await http.get(Uri.parse('$url:$puerto/usuarios/usuarios'),
        headers: headers
    );

    print('los usuarios');
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _usuarios = jsonDecode(response.body);
        _usuariosFiltrados = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los usuarios')),
      );
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _usuariosFiltrados = _usuarios.where((user) {
        final name = user["nombre"].toLowerCase();
        final lastname = user["apellido"].toLowerCase();
        final rol = user["rol"].toLowerCase();
        return name.contains(query.toLowerCase()) ||
            lastname.contains(query.toLowerCase()) ||
            rol.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuarios")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar por nombre, apellido o rol...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _filterUsers, // Filtra mientras escribe
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _usuariosFiltrados.length,
              itemBuilder: (context, index) {
                final user = _usuariosFiltrados[index];
                print("El usuario es: $user");

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: _getRoleIcon(user["rol"]),
                    title: Text("Nombre: ${user["nombre"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Apellido: ${user["apellido"]}"),
                        Text("Puesto: ${user["rol"]}", style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage(usuario: user)),
                            );
                            // Recargamos la pagina con los cambios
                            _loadUsuarios();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            mostrarDialogoConfirmacion(
                              context: context,
                              mensaje: '¿Deseas eliminar a ${user["nombre"]}?',
                              onDelete: () async {
                                // Aquí va la lógica de borrado
                                await ApiServiciosCuentas.suprimirUsuario(user["id_usuario"]);

                                setState(() {
                                    _usuarios.removeWhere((u) => u["id_usuario"] == user["id_usuario"]);
                                    _usuariosFiltrados.removeWhere((u) => u["id_usuario"] == user["id_usuario"]);
                                  });
                                }
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case "Cocinero":
        return Icon(Icons.restaurant, color: Colors.orange, size: 30);
      case "Aseador":
        return Icon(Icons.room_service, color: Colors.blue, size: 30);
      case "Admin":
        return Icon(Icons.admin_panel_settings, color: Colors.red, size: 30);
      case "Responsable":
        return Icon(Icons.manage_accounts, color: Colors.red, size: 30);
      case "Vendedor":
        return Icon(Icons.sell, color: Colors.red, size: 30);
      default:
        return Icon(Icons.person, color: Colors.grey, size: 30);
    }
  }
}
