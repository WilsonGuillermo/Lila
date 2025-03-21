import 'package:flutter/material.dart';

import 'package:tienda/Transverso/identificacion.dart';


import 'package:tienda/profiles/PaginaPerfilCocinero.dart';

// Clase para la página de perfil de Cocinero
class PaginaIngredientesCocinero extends PaginaPerfilCocinero {
  PaginaIngredientesCocinero({required Profile perfil}) : super(perfil: perfil);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'La Tienda -- Menú para tratar los productos',
            ),
          ),
        );
  }
}
