import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/Transverso/borraNavigacion.dart';
import 'package:tienda/Transverso/articulos.dart';
import 'package:tienda/Transverso/stockage.dart';
import 'package:tienda/profiles/PaginaPerfilAdmin.dart';

// Clase para la página de perfil de Cocinero
class PaginaIngredientesAdmin extends PaginaPerfilAdmin {
  PaginaIngredientesAdmin({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // permite la accion de retroceso
      onWillPop: () async {
        Navigator.pop(context); // Regresa sin modificar la pila
        print('--------------');

        //vaciarCamposYNavigacion(context,PaginaPerfilAdmin(perfil));

        print('--------------');

        return false; // Evita que la pagina simplemente haga "pop"
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'La Tienda -- Pagina del Administrador Productos'
          ),
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
              title:const Text('Ocuparse de los productos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticulosPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Consultar stock de los productos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockagePage(),
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
