import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/Transverso/borraNavigacion.dart';
import 'package:tienda/Transverso/token_helper.dart';
import 'package:tienda/profiles/PaginaPerfilAdmin.dart';
import 'package:tienda/profiles/admin/productos/PaginaAgregarProducto.dart';
import 'package:tienda/profiles/admin/productos/PaginaListarProductos.dart';

// Clase para la página de perfil de Cocinero
class PaginaProductosAdmin extends PaginaPerfilAdmin {
  PaginaProductosAdmin({required Profile perfil}) : super(perfil: perfil);

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
              'La Tienda -- Pagina Gestion de los productos'),
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
              title: const Text('Agregar un Producto'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaginaAgregarProducto(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Modificar un Producto'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaginaListarProducto(),
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
