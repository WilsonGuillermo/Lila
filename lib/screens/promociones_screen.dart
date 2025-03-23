import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tienda/screens/detalle_producto_screen.dart';
import 'package:tienda/servicios/api_servicios.dart';
import 'package:tienda/modelos/producto.dart';
import 'package:tienda/screens/agregar_producto_screen.dart';

class PaginaSaldos extends StatefulWidget {
  final int genero; // "femenino" o "masculino"

  PaginaSaldos({required this.genero});

  @override
  _PaginaSaldosState createState() => _PaginaSaldosState();
}

class _PaginaSaldosState extends State<PaginaSaldos> {
  List<dynamic> productosEnPromocion = [];
  final ApiServicios apiService = ApiServicios();

  @override
  void initState() {
    super.initState();
    _cargarProductosEnPromocion();
  }

  Future<void> _cargarProductosEnPromocion() async {
    // 🔥 Aquí llamas al backend para obtener los productos en promoción
    final response = await apiService.obtenerProductosEnSaldos(widget.genero);
    //final response = await ApiServices.obtenerProductosEnSaldos(widget.genero);

    if (response != null) {
      setState(() {
        productosEnPromocion = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saldos ${widget.genero}")),
      body: productosEnPromocion.isEmpty
          ? Center(child: CircularProgressIndicator()) // Cargando...
          : ListView.builder(
              itemCount: productosEnPromocion.length,
              itemBuilder: (context, index) {
                final producto = productosEnPromocion[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(producto['imagen']), // Imagen del producto
                    title: Text(producto['nombre']),
                    subtitle: Text("Antes: \$${producto['precio_original']} \nAhora: \$${producto['precio_oferta']}"),
                    trailing: Icon(Icons.shopping_cart),
                    onTap: () {
                      // 🚀 Aquí puedes agregar la funcionalidad para comprar
                    },
                  ),
                );
              },
            ),
    );
  }
}

