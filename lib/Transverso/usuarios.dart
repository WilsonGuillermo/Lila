import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:tienda/parametros.dart';

import 'package:http/http.dart' as http;
import 'package:tienda/profiles/PaginaPerfilCocinero.dart';
import 'package:tienda/cantidadmasomenos.dart';
import 'package:tienda/stock.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  List<String> Productos = []; // Va contenir solamente el nombre del producto
  List<String> Cantidades = [];

  List<String> Todos = []; // Va contenir el nombre del producto y la cantidad

  List<String> ListaProductos = [];

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  //print('mi backend es : $url:$puerto');

  Future<void> ingredientesRef(BuildContext context) async {
    try {
      //String url = '$url:$puerto/ingredientes_referencial';

      final response =
          await http.get(Uri.parse('$url:$puerto/ingredientes_referencial'));

      print('requete enviada 2');

      handleResponse(response, context);
    } catch (error) {
      // Manejar errores de connexion u otros
      print('requete enviada 3 con error');
      print('Error: $error');
    }
    //return productosRef;
  }

  void handleResponse(http.Response response, BuildContext context) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // Procesar la respuesta si la solicitud fue exitosa
      print('regreso de la requete enviada');
      //print('Los productos (data) son: $response.body['productos']');
      List<dynamic> data = json.decode(response.body)['productos'];

      print('Los productos (data) son: $data');
      //final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Debemos convertir nuestra List<dynamic> en List<String>
      // debemos iterar con map cada elemento de la lista y convertirlo en String

      try {
        Todos = data.map((item) => item.toString()).toList();
        Productos = data.map((item) => item[0].toString()).toList();
        //IngredientesPage().ingredientesRef(context);
        print('Los productos son y antes de llamar: $Productos');
        print('Todo el contenido es: $Todos');
        Cantidades = data.map((item) => item[1].toString()).toList();
        print('las cantidades son: $Cantidades');
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
      ListaProductos = Productos;
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
        title: Text(
          'La Boutique de Angela y Andrea -- Lista de productos',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            backgroundColor: Colors.lightBlueAccent,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
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
            //print(ListaProductos[index]),
            title: Text(ListaProductos[index]),
            onTap: () {
              _mostrarOpcionesProducto(context, ListaProductos[index]);
            },
          );
        },
      );
    }
  }

///////////
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
                child: Text('Aumentar Stock'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para disminuir el stock del producto
                  _disminuirStock(producto);
                  // Puedes abrir otro diálogo para que el usuario ingrese la cantidad
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: Text('Disminuir Stock'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  _verificarStock(producto, "Unico");
                  //Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: Text('Verificar Stock'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para verificar el stock del producto
                  Navigator.pop(context); // Cerrar el diálogo actual
                },
                child: Text('Anular'),
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
          title: Text('Stock del producto: a buscar'),
          content: Text('El stock actual es: XXXX'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  StockPage().stock(context, producto, accion);
                  //Navigator.of(context).pop();
                });
              },
              child: Text('Cerrar'),
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
            decoration: InputDecoration(labelText: 'Cantidad'),
            onChanged: (value) {
              cantidad = int.parse(value);
              //cantidad = int.tryParse(value);
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
              child: Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
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
          title: Text('Error de inicio de sesión'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //_clearFields();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deNuevoDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('De nuevo'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                //_clearFields();
              },
              child: Text('Si'),
            ),
            ElevatedButton(
              onPressed: () {
                //_mostrarOpcionesProducto(context, producto);
                Navigator.pop(context);
                //_clearFields();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
