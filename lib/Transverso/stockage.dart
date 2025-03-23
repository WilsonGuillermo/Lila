import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tienda/Transverso/parametros.dart';
import 'package:tienda/Transverso/stockPdf.dart';

class StockagePage extends StatefulWidget {
  @override
  _StockagePageState createState() => _StockagePageState();
}

class _StockagePageState extends State<StockagePage> {
  List<String> Productos = []; // Va contenir solamente el nombre del producto

  List<String> Todos = []; // Va contenir el nombre del producto y la cantidad

  List<String> ListaProductos = [];

  List<dynamic> ListaProductosOk = [];
  List<dynamic> data = [];

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  //print('mi backend es : $url:$puerto');

  Future<void> stockage(BuildContext context) async {
    // String eureka = '$cantidad';

    print('--------1-----------');

    // Recuperacion parametros backend
    String url = Parametros.direccionBackend;
    int puerto = Parametros.puerto;

    List<String> Productos = [];

    List<String> ListaProductos = [];

    try {
      final response = await http.post(
        Uri.parse('$url:$puerto/stockProducto'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'producto': "ingredientes",
          'accion': "Todo",
        }),
      );
      print('--------2-----------');
      handleResponse(response, context);
      print('---------3----------');
    } catch (error) {
      // Manejar errores de connexion u otros
      print('requete enviada 3333 con error');
      print('Error: $error');
      _showErrorDialog(context, 'Demarrer le Backend, por favor.');
    }
    //return productosRef;
  }

  void handleResponse(http.Response response, BuildContext context) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // Procesar la respuesta si la solicitud fue exitosa
      print('regreso de la requete enviada');

      data = json.decode(response.body);

      print('En HANDLE, Los productos (data) son: $data');

      try {
        Todos = data.map((item) => item.toString()).toList();
        Productos = data.map((item) => item[0].toString()).toList();
        //IngredientesPage().ingredientesRef(context);
        //print('Los productos son y antes de llamar: $Productos');
        //print('Todo el contenido es: $Todos');
      } catch (error) {
        // Manejar errores de connexion u otros
        //print('requete enviada 4 con error');
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

  void cargarListaProductos(BuildContext context) async {
    //await handleResponse(response, context);
    await stockage(context);
    setState(() {
      //ListaProductos = Productos;
      print('______________Data tiene__________');
      //print($data);
      ListaProductosOk = data;
      //ListaProductos = Todos;
      print('en CARGAR, los elementos q tiene la lista son:');
      //print(ListaProductosOk.length);
      //print(ListaProductosOk);

      //print('-------------Aqui el problema-----------');
    });
  }

  @override
  void initState() {
    super.initState();
    cargarListaProductos(context);
    // Llamamos a la función para cargar los productos al inicializar la página
  }

  @override
  Widget build(BuildContext context) {
    print('____________________________________');
    print('flutter trabajando');
    print('____________________________________');

    return Scaffold(
      appBar: AppBar(
        title: const Text( 'La Tienda -- Lista de productos y sus cantidades'),
      ),
      body: _buildProductosList(context),
    );
  }

  Widget _buildProductosList(BuildContext context) {
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
      print('la cantida de elementos q tiene la lista :');

      print(data.length);

      //return ProductosPdfPage(data).build(context);
      return ProductosPdfPage(data);
    }
  }

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
}
