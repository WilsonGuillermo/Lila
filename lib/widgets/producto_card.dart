import 'package:flutter/material.dart';
import 'package:tienda/modelos/producto.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(product.description),
            SizedBox(height: 5),
            Text('Price: ${product.price}'),
            Text('Size: ${product.size}'),
            Text('Color: ${product.color}'),
            Text('Stock: ${product.stock}'),
          ],
        ),
      ),
    );
  }
}
