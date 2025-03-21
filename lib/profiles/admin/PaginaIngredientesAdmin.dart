import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/Transverso/articulos.dart';
import 'package:tienda/Transverso/stockage.dart';
import 'package:tienda/profiles/PaginaPerfilAdmin.dart';

// Clase para la página de perfil de Cocinero
class PaginaIngredientesAdmin extends PaginaPerfilAdmin {
  PaginaIngredientesAdmin({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'La Tienda -- Pagina del Administrador Productos'
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
        ],
      ),
    );
  }
}
