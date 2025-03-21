import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/profiles/PaginaPerfilAdmin.dart';
import 'package:tienda/profiles/admin/usuarios/PaginaAgregarUsuario.dart';
import 'package:tienda/profiles/admin/usuarios/PaginaModificarUsuario.dart';

// Clase para la página de perfil de Cocinero
class PaginaUsuariosAdmin extends PaginaPerfilAdmin {
  PaginaUsuariosAdmin({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'La Tienda -- Pagina Gestion de Usuarios'),
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
                    //builder: (context) => StockagePage(),
                  ));
            },
          ),
          ListTile(
            title: const Text('Modificar un Usuario'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaModificarUsuario(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
