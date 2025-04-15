import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/dialogos.dart';
import 'package:tienda/Transverso/token_helper.dart';
import 'package:tienda/modelos/productos.dart';

class PaginaAgregarProducto extends StatefulWidget {
  @override
  _PaginaAgregarProductoState createState() => _PaginaAgregarProductoState();
}

class _PaginaAgregarProductoState extends State<PaginaAgregarProducto> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String descripcion = '';
  int tipoTiendaId = 1;

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  List<ProductoVariacion> listaVariaciones = [];
  //List<Variacion> listaVariedades = [];

  void _agregarVariacion() async {
    final nuevaVariacion = await showDialog<ProductoVariacion>(
      context: context,
      builder: (context) {
        String descripcionVar = '';
        double precio = 0;
        int stock = 0;

        String nombreAtributo = '';
        String valorAtributo = '';
        List<AtributoProducto> atributos = [];

        final formKeyDialog = GlobalKey<FormState>();
        final atributoFormKey = GlobalKey<FormState>();

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Agregar variación'),
            content: Form(
              key: formKeyDialog,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Descripción'),
                      onChanged: (val) => descripcionVar = val,
                      validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => precio = double.tryParse(val) ?? 0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => stock = int.tryParse(val) ?? 0,
                    ),
                    Divider(),
                    Form(
                      key: atributoFormKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Nombre'),
                              onChanged: (val) => nombreAtributo = val,
                              validator: (val) => val!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Valor'),
                              onChanged: (val) => valorAtributo = val,
                              validator: (val) => val!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (atributoFormKey.currentState!.validate()) {
                                setState(() {
                                  atributos.add(AtributoProducto(
                                    nombre: nombreAtributo,
                                    valor: valorAtributo,
                                  ));
                                  nombreAtributo = '';
                                  valorAtributo = '';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Atributos agregados:'),
                    ...atributos.map((a) => ListTile(
                      title: Text('${a.nombre}: ${a.valor}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            atributos.remove(a);
                          });
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
              TextButton(
                onPressed: () {
                  if (formKeyDialog.currentState!.validate()) {
                    Navigator.pop(
                      context,
                      ProductoVariacion(
                        descripcion: descripcionVar,
                        precio: precio,
                        stock: stock,
                        atributos: atributos,
                      ),
                    );
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          );
        });
      },
    );

    if (nuevaVariacion != null) {
      setState(() {
        listaVariaciones.add(nuevaVariacion);
      });
    }
  }


  void _crearProducto() {
    if (_formKey.currentState!.validate()) {
      final producto = ProductoCombo(
        nombre: nombre,
        descripcion: descripcion,
        tipoTiendaId: tipoTiendaId,
        variaciones: listaVariaciones,
      );

      crearProductoCompleto(producto); // Asegúrate que esta función hace el POST correctamente
    }
  }

  Future<void> crearProductoCompleto(ProductoCombo producto) async {

    final headers = await getHeadersConToken();

    print("el producto creado es: $producto.['nombre']");

    final response = await http.post(
      Uri.parse('$url:$puerto/productos/productos/completo'),
      headers: headers,
      body: jsonEncode(producto.toJson()),
    );

    print('los productos');
    print(response.body);

    if (response.statusCode == 200) {
      print("Producto creado correctamente.");
    } else {
      print("Error al crear producto: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo producto")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) => nombre = val,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (val) => val!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                onChanged: (val) => descripcion = val,
                decoration: InputDecoration(labelText: "Descripción"),
                validator: (val) => val!.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _agregarVariacion, child: Text("Agregar variación")),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _crearProducto, child: Text("Crear producto")),
            ],
          ),
        ),
      ),
    );
  }


  void main() {
    runApp(MaterialApp(
      home: PaginaAgregarProducto(),
    ));
  }
}
