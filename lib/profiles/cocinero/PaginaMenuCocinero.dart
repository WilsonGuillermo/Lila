import 'package:flutter/material.dart';
import '../../perfil.dart';
import '../../main.dart';

// Clase para la página de perfil de Cocinero
class PaginaMenuCocinero extends PaginaPerfilCocinero {
  PaginaMenuCocinero({required Profile perfil}) : super(perfil: perfil);

//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La Boutique de Angela y Andrea'),
        title: Text('Menú para tratar los productos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Iniciar sesión'),
            ),
          ]),
        ),
      ),
    );
  }
//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú para tratar los productos'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Agregar la cantidad de un producto'),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('disminuir la cantidad de un producto'),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('Verificar el stock de un producto'),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('Verificar el stock de todos los productos'),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}