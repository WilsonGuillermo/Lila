import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tienda/servicios/api_servicios.dart';
import 'package:tienda/modelos/categoria.dart';
import 'package:tienda/screens/producto_screen.dart';
import 'package:tienda/screens/promociones_screen.dart';
import 'package:tienda/tipos/tipos.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  final ApiServicios apiService = ApiServicios();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    print("wwwwwwwwwwwwwwwwwww__HomeScreenState");
  }

  Future<void> _fetchCategories() async {
    final fetchedCategories = await apiService.getCategories();

    setState(() {
      categories = fetchedCategories; // Cargamos las categorias
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La Tienda -- De todo para todos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: categories.isEmpty
                ? Center(child: CircularProgressIndicator()) // Muestra un Cargador si la lista esta vacia
                : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: _buildProductosParaEllas(context, categories[0].id),
                ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      title: Text(category.name,
                        textAlign: TextAlign.center),
                      subtitle: Text(category.description,
                        textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(categoryId: category.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: categories.isEmpty
                  ? Center(child: CircularProgressIndicator()) // Muestra un Cargador si la lista esta vacia
                  : Padding(
                padding: const EdgeInsets.all(5.0),
                //child: _buildProductosMasculinos(context, categories[1].id),
                child:  _buildProductosParaEllos(context, categories[1].id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosParaEllos(BuildContext context, int categories) {
    //final categoria = categories.first;
    final int categoria = categories;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 10.0, // espacio horizontal entre los botones
              runSpacing: 10.0, // Espacio vertical entre filas
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    _mostrarDialogo("trajes", categoria);
                  },
                  label: const Text('Trajes'),
                  icon: Icon(Icons.man_2),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _mostrarDialogo("pantalonesH", categoria);
                  },
                  label: const Text('Pantalones'),
                  icon: Icon(Icons.man_2),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarDialogo("camisasH", categoria);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber),
                  child: const Text('Camisas'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarDialogo("camisetas", categoria);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber),
                  child: const Text('Camisetas'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarDialogo("jeansH", categoria);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber),
                  child: const Text('Jeans'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarDialogo("bermudas", categoria);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber),
                  child: const Text('Bermudas'),
                ),
              ],
            ),

            SizedBox(height: 10), // Espacio entre el titulo y los botones

            ElevatedButton(
              //icon: Icon(Icons.local_offer, color: Colors.white), // Ícono de oferta
              //label: Text("Saldos"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0), // Mas grande
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Bordes redondos
                ),
                elevation: 8, // Sombra para q resalte mas
              ),
              child: const Text(
                "SUPER SALDOS",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaSaldos(genero: categoria), // "femenino"
                  ),
                );
              },
            ),

            SizedBox(height: 10), // Espacio entre el boton saldos y el titulo

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Todo para Ellos',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06, // Reduce el tamano dinamicamente
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _buildProductosParaEllas(BuildContext context, int categories ) {
    final int categoria = categories;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: RichText(
                text: TextSpan(
                  text: 'Todo para Ellas',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06, // Reduce el tamano dinamicamente
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10), // Espacio entre el titulo y el boton saldos

          ElevatedButton(
            //icon: Icon(Icons.local_offer, color: Colors.white), // Ícono de oferta
            //label: Text("Saldos"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0), // Mas grande
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Bordes redondos
              ),
              elevation: 8, // Sombra para q resalte mas
            ),
            child: const Text(
              "SUPER SALDOS",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaginaSaldos(genero: categoria), // "femenino"
                ),
              );
            },
          ),

          SizedBox(height: 10), // Espacio entre el boton saldos y los otros botones

          Wrap(
            spacing: 10.0, // espacio horizontal entre los botones
            runSpacing: 10.0, // Espacio vertical entre filas
            alignment: WrapAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  _mostrarDialogo("vestidos", categoria);
                },
                label: const Text('Vestidos'),
                icon: Icon(Icons.woman_2_rounded),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _mostrarDialogo("faldas", categoria);
                },
                label: const Text('Faldas'),
                icon: Icon(Icons.woman_2),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  _mostrarDialogo("blusas", categoria);
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                label: const Text('Blusas'),
                icon: Icon(Icons.woman_2_outlined),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  _mostrarDialogo("camisas", categoria);
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                label: const Text('Camisas'),
                icon: Icon(Icons.woman_2_outlined),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  _mostrarDialogo("pantalones", categoria);
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                label: const Text('Pantalones'),
                icon: Icon(Icons.woman_2_rounded),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _mostrarDialogo("jeans", categoria);
                },
                label: const Text('Jeans'),
                icon: Icon(Icons.woman_2_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarDialogo(String tipo, int categoria) {
    print("----------2-mostrarDialogo----");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("----------255555-mostrarDialogo----");
        return AlertDialog(
          title: Text(tipo),
          //actions: [
          actions: <Widget> [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TiposScreen(tipo: tipo, categoria: categoria),
                  ),
                );
              },
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );

      },
    );
  }
}