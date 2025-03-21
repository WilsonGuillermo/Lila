import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tienda/servicios/api_servicios.dart';
import 'package:tienda/screens/agregar_producto_screen.dart';
import 'package:tienda/servicios/api_services.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late Future<List<dynamic>> _products;
  late Future<List<dynamic>> productos_a_detallar;

  @override
  void initState() {
    super.initState();
    _products = ApiServicios.getProducts();
    productos_a_detallar = ApiServicios.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay productos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var product = snapshot.data![index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(product['description']),
                  leading: CachedNetworkImage(
                    imageUrl: product['imageUrl'] ?? '',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final updatedProduct = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFormScreen(product: product),
                            ),
                          );
                          if (updatedProduct != null) {
                            setState(() {
                              _products = ApiServicios.getProducts();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          ApiServices.deleteProduct(product['id']).then((response) {
                            if (response) {
                              setState(() {
                                _products = ApiServices.getProducts();
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(imageUrl: product['imageUrl'] ?? ''),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductFormScreen(),
            ),
          );
          if (newProduct != null) {
            setState(() {
              _products = ApiServices.getProducts();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}