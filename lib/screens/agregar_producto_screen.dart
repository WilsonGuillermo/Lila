import 'package:flutter/material.dart';
//import 'package:tienda/screens/image_screen.dart';
//import 'package:tienda/servicios/api_servicios.dart';
//import 'package:tienda/modelos/producto.dart';
//import 'package:tienda/screens/image_screen.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String description;
  late double price;
  late int categoryId;
  late String size;
  late String color;
  late int stock;
  late String imagen;
  late String tipo;
  late String referencia;
  late String estilo;
  late String corte;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      name = widget.product!['name'];
      description = widget.product!['description'];
      price = widget.product!['price'];
      categoryId = widget.product!['categoryId'];
      size = widget.product!['size'];
      color = widget.product!['color'];
      stock = widget.product!['stock'];
      imagen = widget.product!['imagen'];
      tipo = widget.product!['tipo'];
      referencia = widget.product!['referencia'];
      estilo = widget.product!['estilo'];
      corte = widget.product!['corte'];
    } else {
      name = '';
      description = '';
      price = 0.0;
      categoryId = 0;
      size = '';
      color = '';
      stock = 0;
      imagen = '';
      tipo = '';
      referencia = '';
      estilo = '';
      corte = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Editar Producto' : 'Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre del producto';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la descripción del producto';
                  }
                  return null;
                },
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el precio del producto';
                  }
                  return null;
                },
                onSaved: (value) => price = double.parse(value!),
              ),
              TextFormField(
                initialValue: categoryId.toString(),
                decoration: InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la categoría del producto';
                  }
                  return null;
                },
                //onSaved: (value) => categoryId = value!,
                onSaved: (value) => categoryId = int.parse(value!),
              ),
              TextFormField(
                initialValue: size,
                decoration: InputDecoration(labelText: 'Talla'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la talla del producto';
                  }
                  return null;
                },
                onSaved: (value) => size = value!,
              ),
              TextFormField(
                initialValue: color,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el color del producto';
                  }
                  return null;
                },
                onSaved: (value) => color = value!,
              ),
              TextFormField(
                initialValue: stock.toString(),
                decoration: const InputDecoration(labelText: 'Cantidad disponible'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la categoría del producto';
                  }
                  return null;
                },
                onSaved: (value) => stock = int.parse(value!),
              ),
              TextFormField(
                initialValue: imagen,
                decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la URL de la imagen del producto';
                  }
                  return null;
                },
                onSaved: (value) => imagen = value!,
              ),
              TextFormField(
                initialValue: estilo,
                decoration: const InputDecoration(labelText: 'Estilo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el estilo del producto';
                  }
                  return null;
                },
                onSaved: (value) => estilo = value!,
              ),
              TextFormField(
                initialValue: corte,
                decoration: const InputDecoration(labelText: 'Corte'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el corte del producto';
                  }
                  return null;
                },
                onSaved: (value) => corte = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Aquí puedes enviar los datos al backend o hacer alguna otra acción
                    Navigator.pop(context, {
                      'name': name,
                      'description': description,
                      'price': price,
                      'category': categoryId,
                      'size': size,
                      'color': color,
                      'stock': stock,
                      'imagen': imagen,
                      'tipo': tipo,
                      'referencia': referencia,
                      'estilo': estilo,
                      'corte': corte,
                    });
                  }
                },
                child: Text(widget.product != null ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
