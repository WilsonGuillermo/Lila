import 'package:flutter/material.dart'; //Il s'agit du package Material de Flutter qui nous permettra d'accéder à de nombreux widgets indispensables à nos applications.

// paginas principales
import 'package:tienda/Transverso/identificacion.dart';

import 'package:tienda/profiles/PaginaPerfilAdmin.dart';
import 'package:tienda/profiles/PaginaPerfilCocinero.dart';
import 'package:tienda/profiles/PaginaPerfilVendedor.dart';
import 'package:tienda/profiles/PaginaPerfilDirigente.dart';

import 'package:tienda/profiles/cocinero/PaginaIngredientesCocinero.dart';
import 'package:tienda/profiles/admin/PaginaIngredientesAdmin.dart';
import 'package:tienda/profiles/admin/PaginaProductosAdmin.dart';
import 'package:tienda/profiles/admin/PaginaUsuariosAdmin.dart';

//import 'package:tienda/screens/producto_screen.dart';

//import 'package:tienda/screens/casa_screen.dart';
//import 'package:tienda/screens/producto_screen.dart';


void main() {
  runApp(MyApp());
} // funcion runApp y q toma la clase Myapp como parametro, un Widget

// Nous déclarons cette nouvelle classe MyApp sous forme de Widget Flutter de type StatelessWidget:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /////// Agregado 190624
      theme: ThemeData(
        // Tema para la barra
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(
            fontFamily: 'Barra',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          toolbarHeight: 70,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Cuerpo',
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Cuerpo',
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Cuerpo',
            fontSize: 12,
          ),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
            elevation: WidgetStatePropertyAll<double>(5.0),
            textStyle: WidgetStatePropertyAll<TextStyle>(
              const TextStyle(
                fontFamily: 'Botones',
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ),
        ),
      ),
      home: LoginPage(),
      routes: {
        // Recuperamos el profil con la propiedad ModalRoute
        '/pagina_de_admin': (context) => PaginaPerfilAdmin(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        '/pagina_de_vendedor': (context) => PaginaPerfilVendedor(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        '/pagina_de_dirigente': (context) => PaginaPerfilDirigente(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        // Todos las acciones del cocinero
        '/pagina_de_cocinero': (context) => PaginaPerfilCocinero(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        '/pagina_ingredientes_cocinero': (context) =>
            PaginaIngredientesCocinero(
                perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        '/pagina_ingredientes_admin': (context) => PaginaIngredientesAdmin(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        '/pagina_productos_admin': (context) => PaginaProductosAdmin(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        '/pagina_usuarios_admin': (context) => PaginaUsuariosAdmin(
            perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        //'/pagina_agregar_usuarios': (context) => PaginaAgregarUsuario(
        //    perfil: ModalRoute.of(context)!.settings.arguments as Profile),
        //'/productos': (context) => ProductScreen(
        //    perfil: ModalRoute.of(context)!.settings.arguments as Profile),
      },
      debugShowCheckedModeBanner: false, // Quita mensaje debug en la pagina
    );
  } // Metodo Build de la clase madre StatelessWidget que nos envia el contenido de nuestra pagina
}
