import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tienda/servicios/api_servicios.dart';
import 'package:tienda/modelos/categoria.dart';
import 'package:tienda/screens/producto_screen.dart';
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
      categories = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La Tienda -- Todo para todos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Center(
            RichText(
              text: TextSpan(
                text: 'Todo para Ellas',
                style: DefaultTextStyle.of(context).style,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: _buildProductosFemeninos(context, categories[0].id),
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
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: _buildProductosMasculinos(context, categories[1].id),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Todo para Ellos',
                style: DefaultTextStyle.of(context).style,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosMasculinos(BuildContext context, int categories) {
    //final categoria = categories.first;
    final int categoria = categories;
    return Column(
      children: <Widget>[
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _mostrarDialogo("trajes", categoria);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.amber),
              child: const Text('Trajes'),
            ),
            ElevatedButton(
              onPressed: () {
                _mostrarDialogo("pantalonesH", categoria);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.amber),
              child: const Text('Pantalones'),
            ),
          ],
        ),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
          ],
        ),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
      ],
    );
  }

  Widget _buildProductosFemeninos(BuildContext context, int categories ) {
    final int categoria = categories;
    return Column(
      children: <Widget>[
        Row (
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
          ],
        ),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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