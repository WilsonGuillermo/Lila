import 'package:flutter/material.dart';

import 'package:tienda/Transverso/articulos.dart';
import 'package:tienda/Transverso/perfil.dart';
import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/Transverso/stockage.dart';


// Clase para la página de perfil de Cocinero
class PaginaPerfilCocinero extends PaginaPerfil {
  PaginaPerfilCocinero({required Profile perfil}) : super(perfil: perfil);

  //IngredientesPage articulo = IngredientesPage();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // permite la accion de retroceso
      canPop: true,
      onPopInvoked: (bool didPop) {
        print('--------------');
        print(didPop);
        if (didPop) {
          _clearFields_bis(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text( 'La Tienda -- Pagina del Cocinero' ),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Ocuparse de los productos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticulosPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Ocuparse de los platos del día'),
              onTap: () {
                // Lógica para ocuparse de los platos del día
                //Navigator.pushReplacementNamed(context, '/pagina_platosdia_cocinero', arguments: perfil);
              },
            ),
            ListTile(
              title: const Text('Ocuparse de los menus'),
              onTap: () {
                // Lógica para ocuparse de los menus
                //Navigator.pushReplacementNamed(context, '/pagina_menus_cocinero', arguments: perfil);
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
                _clearFields_bis(context);
              },
              child: const Text('Cerrar'),
            ),
            Image.asset('assets/images/Calicop16.jpg',
              height: 200,
              width: 400,),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Funcion que nos permite borrar los datos de la pagina de identification
  //////////////////////////////////////////////////////////////////////////////
  void _clearFields_bis(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    });
  }
}
