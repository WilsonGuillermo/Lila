import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tienda/Transverso/parametros.dart';

////////////////////////////////////////////////////////
// Pagina utilisada para conocer el stock de un producto
////////////////////////////////////////////////////////

class StockPage {

  List<String> Productos = [];

  List<String> ListaProductos = [];

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  //Future<void> stock(BuildContext context) async {

  Future<void> stock(BuildContext context, String producto, String accion) async {
    // String eureka = '$cantidad';

    String puesta_al_dia = accion;

    String producto_stock = producto;

    print('accion a realisar $puesta_al_dia');

    print('--------1 bis-----------');

    // Recuperacion parametros backend
    //String url = Parametros.direccionBackend;
    //int puerto = Parametros.puerto;

    try {
      final response = await http.post(
        Uri.parse('$url:$puerto/stockProducto'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'producto': producto_stock,
          'accion': puesta_al_dia,
        }),
      );
      print('--------2 bis-----------');
      handleResponse(response, context);
      print('---------3 bis----------');
    } catch (error) {
      // Manejar errores de connexion u otros
      print('requete enviada 333 con error');
      print('Error: $error');
      _showErrorDialog(context, 'Demarrer le Backend, por favor.');
    }
  }

  void handleResponse(http.Response response, BuildContext context) {
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      String mensaje = '';

      // Procesar la respuesta si la solicitud fue exitosa
      final List<dynamic> responseData = jsonDecode(response.body);

      Productos = responseData.map((item) => item.toString()).toList();
      print('--------------------');
      print(Productos);
      print('--------------------');

      // Trabajando la lista y extraer solamente los datos necesarios //
      String producto = '';
      double cantidad = 0.0;

      for (String item in Productos) {
        Map<String, dynamic> mapa = _parseMap(item);

        if (mapa.containsKey('producto')) {
          producto = mapa['producto'];
        } else if (mapa.containsKey('cantidad')) {
          cantidad = double.parse(mapa['cantidad']);
        }
      }

      print('--------------------');
      mensaje = 'El stock del producto: $producto es $cantidad';
      print(mensaje);
      _showSuccessDialog(context, mensaje);
      //Navigator.pop(context);
    } else {
      // Manejar errores si la solicitud falla
      // Mostrar popup de error de credenciales
      print('Error en la solicitud: ${response.statusCode}');

      _showErrorDialogHTTP(statusCode, context,
          'La bdd esta vacia. Por favor, completa el referencial.');
    }
  }

  Map<String, dynamic> _parseMap(String item) {
    item = item.replaceAll('{', '').replaceAll('}', '');
    List<String> partes = item.split(':');
    //
    return {partes[0].trim(): partes[1].trim()};
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exito'),
          content: Text(message),
          actions: [
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
}
