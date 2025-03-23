import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';

// Clase base para la página de perfil genérica
class PaginaPerfil extends StatelessWidget {
  final Profile perfil;

  PaginaPerfil({required this.perfil});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes definir la interfaz de usuario de la página de perfil genérica
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenido ${perfil.nombre}'),
            // Otros widgets de perfil...
          ],
        ),
      ),
    );
  }
}
