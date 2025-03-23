import 'package:flutter/material.dart';
import 'package:tienda/servicios/api_servicios.dart';
import 'package:tienda/modelos/producto.dart';
import 'package:tienda/widgets/producto_card.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ImagenScreen extends StatelessWidget {
  final String imageUrl;

  const ImagenScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    print("Si tengo url o no: $imageUrl");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda -- Detalle del Producto'),
      ),
      body: Center(
        child: imageUrl != null
          ? CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: ( context, url ) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ) : const Text ('No hay imagen disponible para este producto'),
      ),
    );
  }
}