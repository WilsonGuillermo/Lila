import 'package:flutter/material.dart';

void vaciarCamposYNavigacion(BuildContext context, Widget pagina) {
  // Aqui podemos limpiar cualquier campo
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => pagina),
      (route) => false, // Elimina todas las paginas anteriores de la pila
  );
}