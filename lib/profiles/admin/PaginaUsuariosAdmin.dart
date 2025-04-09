import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/Transverso/borraNavigacion.dart';
import 'package:tienda/profiles/PaginaPerfilAdmin.dart';
import 'package:tienda/profiles/admin/usuarios/PaginaAgregarUsuario.dart';
import 'package:tienda/profiles/admin/usuarios/paginaListarUsuarios.dart';

// Clase para la página de perfil de Cocinero
class PaginaUsuariosAdmin extends PaginaPerfilAdmin {
  PaginaUsuariosAdmin({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // permite la accion de retroceso
      onWillPop: () async {
        print('--------------');
        Navigator.pop(context); // Regresa sin modificar la pila

        print('--------------');

        return false; // Evita que la pagina simplemente haga "pop"
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'La Tienda -- Pagina Gestion de Usuarios'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Regresa a la pagina q lo llamo
              },
          ),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Agregar un Usuario'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaginaAgregarUsuario(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Modificar un Usuario'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserListPage(),
                    ));
              },
            ),
            ElevatedButton(
              onPressed: () {
                vaciarCamposYNavigacion(context,LoginPage());
              },
              child: const Text('Cerrar'),
            ),

          ],
        ),
      ),
    );
  }
}
