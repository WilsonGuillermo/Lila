import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/cantidadmasomenos.dart';
import 'package:tienda/Transverso/stock.dart';
import 'package:tienda/Transverso/token_helper.dart';

class ArticulosPage extends StatefulWidget {
  @override
  _ArticulosPageState createState() => _ArticulosPageState();
}

class _ArticulosPageState extends State<ArticulosPage> {
  List<String> Productos = []; // Va contenir solamente el nombre del producto

  List<String> Todos = []; // Va contenir el nombre del producto y la cantidad

  List<String> ListaProductos = [];

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  Future<void> ingredientesRef(BuildContext context) async {
    final headers = await getHeadersConToken();

    try {
      final response =
          await http.get(
            Uri.parse('$url:$puerto/productos/productos_base'),
            headers: headers,
          );

      print('requete enviada 2');

      handleResponse(response, context);
    } catch (error) {
      // Manejar errores de connexion u otros
      print('requete enviada 3 con error');
      print('Error: $error');
    }
  }

  void handleResponse(http.Response response, BuildContext context) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // Procesar la respuesta si la solicitud fue exitosa
      print('regreso de la requete enviada');
      //final Map<String, dynamic> responseData = jsonDecode(response.body);
      //print('Los productos (data) son: $response.body['productos']');
      print('Los productos son: $response');
      List<dynamic> data = json.decode(response.body); //['productos'];

      print('Los productos (data) son: $data');
      //final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Debemos convertir nuestra List<dynamic> en List<String>
      // debemos iterar con map cada elemento de la lista y convertirlo en String

      try {
        Todos = data.map((item) => item.toString()).toList();
        Productos = data.map((item) => item[1].toString()).toList();
        //IngredientesPage().ingredientesRef(context);
        print('Los productos son y antes de llamar: $Productos');
        print('Todo el contenido es: $Todos');
      } catch (error) {
        // Manejar errores de connexion u otros
        print('requete enviada 4 con error');
        print('Error: $error');
      }
    } else {
      // Manejar errores si la solicitud falla
      // Mostrar popup de error de credenciales
      print('Error en la solicitud: ${response.statusCode}');

      _showErrorDialogHTTP(statusCode, context,
          'La bdd esta vacia. Por favor, completa el referencial.');
    }
  }

  void cargarProductos(context) async {
    //await handleResponse(response, context);
    await ingredientesRef(context);
    setState(() {
      //ListaProductos = Productos;
      ListaProductos = Todos;
      print('los elementos q tiene la lista son:');
      print(ListaProductos.length);
      print(ListaProductos);
    });
  }

  @override
  void initState() {
    super.initState();
    cargarProductos(context);
    // Llamamos a la función para cargar los productos al inicializar la página
  }

  @override
  Widget build(BuildContext context) {
    print('____________________________________');
    print('flutter trabajando');
    print('____________________________________');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'La Tienda -- Lista de productos',
        ),
      ),
      body: _buildProductosList(),
    );
  }

  Widget _buildProductosList() {
    if (Productos.isEmpty) {
      print('____________________________________');
      print('----------------------Productos nulos-----------------');
      print('____________________________________');
      // Muestra un indicador de carga mientras se cargan los productos
      return Center(child: CircularProgressIndicator());
    } else {
      print('____________________________________');
      print('flutter trabajando 2222222222222222');
      print('____________________________________');
      // Construye la lista de productos una vez que se han cargado
      print('los elementos q tiene la lista son:');
      print(ListaProductos.length);
      return ListView.builder(
        itemCount: ListaProductos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ListaProductos[index]),
            onTap: () {
              _mostrarOpcionesProducto(context, ListaProductos[index]);
            },
          );
        },
      );
    }
  }

  void _mostrarOpcionesProducto(BuildContext context, String producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acciones para el producto: $producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Lógica para aumentar el stock del producto
                  _aumentarStock(producto);
                  // Puedes abrir otro diálogo para que el usuario ingrese la cantidad
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: const Text('Aumentar Stock'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para disminuir el stock del producto
                  _disminuirStock(producto);
                  // Puedes abrir otro diálogo para que el usuario ingrese la cantidad
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: const Text('Disminuir Stock'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  _verificarStock(producto, "Unico");
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: const Text('Verificar Stock'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: const Text('Anular'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _aumentarStock(String producto) {
    _mostrarDialogo(producto, 'Aumentar');
  }

  void _disminuirStock(String producto) {
    _mostrarDialogo(producto, 'Disminuir');
  }

  void _verificarStock(String producto, String accion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Stock de ${producto.nombre}'),
          //content: Text('El stock actual es: ${producto.stock}'),
          title: Text('Informacion del producto: $producto'),
          content: Text('Stock del producto: $producto'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  StockPage().stock(context, producto, accion);
                  //Navigator.of(context).pop();
                });
              },
              child: const Text('Buscar'),
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

  void _mostrarDialogo(String producto, String accion) {
    int cantidad = 0;

    String message = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('$accion stock de ${producto.nombre}'),
          title: Text('$accion stock de ${producto}'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad'),
            onChanged: (value) {
              cantidad = int.parse(value);
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (cantidad > 0) {
                  setState(() {
                    CantidadMasoMenosPage()
                        .cantidadMasoMenos(context, producto, cantidad, accion);
                  });
                } else {
                  _showErrorDialog(
                      context, 'Por favor, entre la cantidad deseada.');
                }
              },
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

////////////////
  void _showErrorDialogHTTP(
      int RespuestaHTTP, BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo emergente
              },
              style: TextButton.styleFrom(
                //primary: Colors.redAccent,
                padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                textStyle: const TextStyle(fontSize: 25),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //_clearFields();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deNuevoDialog_borrar(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('De nuevo'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                //_clearFields();
              },
              child: const Text('Si'),
            ),
            ElevatedButton(
              onPressed: () {
                //_mostrarOpcionesProducto(context, producto);
                Navigator.pop(context);
                //_clearFields();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
