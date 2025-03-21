import 'package:flutter/material.dart';

import 'package:tienda/Transverso/perfil.dart';
import 'package:tienda/Transverso/identificacion.dart';
//import 'package:tienda/profiles/vendedor/VendiendoProductos.dart';
import 'package:tienda/screens/casa_screen.dart';

// Clase para la página de perfil de Vendedor
class PaginaPerfilVendedor extends PaginaPerfil {
  PaginaPerfilVendedor({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú de Vendedor'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Ocuparse de las mesas'),
            onTap: () {
              // Lógica para ocuparse de los productos
            },
          ),
          ListTile(
            title: const Text('Ocuparse de los pedidos'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            },
          ),
          ListTile(
            title: const Text('Ocuparse de los pagos'),
            onTap: () {
              // Lógica para ocuparse de las bebidas
            },
          ),
          Image.asset('assets/images/cali-niche.PNG',
            height: 100,
            width: 200,
          ),
        ],
      ),
    );
  }
}
