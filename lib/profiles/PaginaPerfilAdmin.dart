import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:tienda/Transverso/perfil.dart';
import 'package:tienda/Transverso/identificacion.dart';
import 'package:tienda/Transverso/borraNavigacion.dart';
import 'package:tienda/Transverso/token_helper.dart';
import 'package:tienda/Transverso/cambiarContrasena.dart';

// Clase para la página de perfil de Cocinero
class PaginaPerfilAdmin extends PaginaPerfil {
  PaginaPerfilAdmin({required Profile perfil}) : super(perfil: perfil);

  /////////////////////////////////////////////////////////
  /// El regreso (<-) vacea los campos usuario/contrasena
  /////////////////////////////////////////////////////////
  bool pasaOnoPasa = false;
  int identUsuario = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // permite la accion de retroceso
        onWillPop: () async {
          print('--------------');

          vaciarCamposYNavigacion(context,LoginPage());

          print('--------------');

          return false; // Evita que la pagina simplemente haga "pop"
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'La Tienda -- Pagina del Administrador'
            ),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: const Text('Ocuparse de los productos de la cocina'),
                onTap: () {
                  // Lógica para ocuparse de los productos
                  //Navigator.pushReplacementNamed( // se utiliza para borrar de la pila la pagina que envia
                  Navigator.pushNamed(
                      context,
                      '/pagina_ingredientes_admin',
                      arguments: perfil
                  );
                },
              ),
              ListTile(
                title: const Text('Ocuparse de los productos de la tienda'),
                onTap: () {
                  // Lógica para ocuparse de los productos
                  //Navigator.pushReplacementNamed( // se utiliza para borrar de la pila la pagina que envia
                  Navigator.pushNamed(
                      context,
                      '/pagina_productos_admin',
                      arguments: perfil
                  );
                },
              ),
              ListTile(
                title: const Text('Ocuparse del referencial'),
                onTap: () {
                  // Lógica para ocuparse de los platos del día
                },
              ),
              ListTile(
                title: const Text('Ocuparse de los usuarios'),
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      '/pagina_usuarios_admin',
                      arguments: perfil
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final Map<String, dynamic> utilisador = await recuperarDatosUsuario();
                  pasaOnoPasa = utilisador['primerAcceso'];
                  identUsuario = utilisador['idUsuario'];
                  if (identUsuario != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CambiarContrasenaPage(
                          id_usuario: identUsuario,
                          primerAcceso: pasaOnoPasa,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.lock_reset),
                label: Text('Cambiar contraseña'),
              ),
              ElevatedButton(
                onPressed: () {
                  vaciarCamposYNavigacion(context,LoginPage());
                  //_clearFields_bis(context);
                },
                child: const Text('Cerrar'),
              ),
              Image.asset('assets/images/images_cop16.PNG',
                height: 200,
                width: 400
              ),
            ],
          ),
        ));
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
