import 'package:flutter/material.dart';

import 'package:tienda/Transverso/perfil.dart';
import 'package:tienda/Transverso/identificacion.dart';

// Clase para la página de perfil de Dirigente
class PaginaPerfilDirigente extends PaginaPerfil {
  PaginaPerfilDirigente({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú del Dirigente'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Ocuparse de las estadisticas'),
            onTap: () {
              // Lógica para ocuparse de los productos
            },
          ),
          ListTile(
            title: const Text('Ocuparse de las finanzas'),
            onTap: () {
              // Lógica para ocuparse de los platos del día
            },
          ),
          Image.asset('assets/images/Calicop16.JPG',
            height: 100,
            width: 200,
          ),
        ],
      ),
    );
  }
}
