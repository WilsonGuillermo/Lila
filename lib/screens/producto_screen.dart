import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tienda/screens/detalle_producto_screen.dart';
import 'package:tienda/servicios/api_servicios.dart';
import 'package:tienda/modelos/producto.dart';
import 'package:tienda/screens/agregar_producto_screen.dart';


class ProductScreen extends StatefulWidget {
  final int categoryId;

  ProductScreen({required this.categoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  final ApiServicios apiService = ApiServicios();
  late Future<List<dynamic>> _products;
  String quien = "";


  //if categoryId == 1 {
  //  quien = "La tienda -- Productos femeninos";
  //}
  //else {
  //  quien = "La tienda -- Productos Masculinos";
  //}

  @override
  void initState() {
    super.initState();
    _fetchProductsByCategory();

    print("wwwwwwwwwwwwwwwwwww__ProductScreenState");
    _products = apiService.getProducts();
  }

  Future<void> _fetchProductsByCategory() async {
    final fetchedProductsByCategory = await apiService.getProductsByCategory(widget.categoryId);
    setState(() {
      products = fetchedProductsByCategory;
    });
  }

  String _tituloCategoria(int categoria){
    switch (categoria){
      case 1 :
        return "La tienda -- Productos femeninos";
      case 2 :
        return "La tienda -- Productos masculinos";
      default :
        return "La tienda -- Productos";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloCategoria(widget.categoryId)),
        //title: Text('yo'),
      ),
      body: ListView.builder(
        //future: _products,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          //final imageUrl = product.imageUrl;
          print("Antes Si tengo url o no: ${products[index].imagen}");

          return ListTile(
            leading: InkWell(
              onTap: () {
                if (product.imagen != null) {
                  print("Si tengo url o no: ${product.imagen}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => ImagenScreen(imageUrl: product.imageUrl!),
                      builder: (context) => DetalleProductoScreen(product: product.toJson()),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No hay imagen disponible para este producto.')),
                  );
                }
              },
              child: SizedBox(
                width: 56.0,
                height: 56.0,
                child: product.imagen != null
                    ? CachedNetworkImage(
                  imageUrl: product.imagen!,
                  placeholder: ( context, url ) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
                    : const Text ('No hay imagen disponible para este producto'),
              ),
            ),

            title: Text(product.name),
            subtitle: Text(product.description),
            //trailing: Text('\$${product.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedProduct = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductFormScreen(product: product.toJson()),
                      ),
                    );
                    if (updatedProduct != null) {
                      setState(() {
                        _products = apiService.getProducts();
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    apiService.deleteProduct(product.id).then((response) {
                      if (response) {
                        setState(() {
                          _products = apiService.getProducts();
                        });
                      }
                    });
                  },
                ),
              ],
            ),

          );
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
            setState(
                    () {
                  _products = apiService.getProducts();
                }
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}