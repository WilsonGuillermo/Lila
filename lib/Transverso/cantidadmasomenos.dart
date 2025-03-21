import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tienda/Transverso/parametros.dart';

class CantidadMasoMenosPage {
  List<String> Productos = [];

  List<String> ListaProductos = [];

  // Recuperacion parametros backend
  String url = Parametros.direccionBackend;
  int puerto = Parametros.puerto;

  Future<void> cantidadMasoMenos(BuildContext context, String Producto,
      int cantidad, String accion) async {
    String eureka = '$cantidad';

    String puesta_al_dia = accion;

    // Recuperacion parametros backend
    String url = Parametros.direccionBackend;
    int puerto = Parametros.puerto;

    try {
      final response = await http.post(
        Uri.parse('$url:$puerto/cantidadProducto'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'producto': Producto,
          'cantidad': eureka,
          'accion': puesta_al_dia,
        }),
      );

      handleResponse(response, context);
    } catch (error) {
      // Manejar errores de connexion u otros
      print('requete enviada 33 con error');
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
      mensaje = 'Nuevo stock del producto: $producto es $cantidad';
      print(mensaje);
      _showSuccessDialog(context, mensaje);
      //Navigator.pop(context);
    } else {
      // Manejar errores si la solicitud falla
      // Mostrar popup de error de credenciales
      print('Error en la solicitud: ${response.statusCode}');

      _tratarReponseNegativa(response, context);
    }
  }

  void _tratarReponseNegativa(http.Response response, BuildContext context) {
    String mensaje = '';

    final List<dynamic> responseData = jsonDecode(response.body);
    //print('El error recuperado es: $responseData');

    Productos = responseData.map((item) => item.toString()).toList();
    print('--------------------');
    print(Productos);
    print('--------------------');

    //_parcero(Productos, context);

    String producto = '';
    double cantidad = 0.0;
    String resultado = '';
    String respuesta = '';

    for (String item in Productos) {
      Map<String, dynamic> mapa = _parseMap(item);

      if (mapa.containsKey('producto')) {
        producto = mapa['producto'];
      } else if (mapa.containsKey('cantidad')) {
        cantidad = double.parse(mapa['cantidad']);
      } else if (mapa.containsKey('resultado')) {
        resultado = mapa['resultado'];
      }

      print('Producto: $producto');
      print('Cantidad: $cantidad');
      print('respuesta: $resultado');
    }

    print('--------------------');
    respuesta = resultado;
    print('--------------------');

    print(respuesta);
    print('--------------------');

    if (resultado == 'KO_1') {
      mensaje =
          'La cantidad actual $cantidad del producto $producto es inferior a la cantidad pedida';
      _showErrorDialog(context, mensaje);
    } else if (resultado == 'KO_2') {
      mensaje = 'El producto $producto no esta en stock';
      _showErrorDialog(context, mensaje);
    } else {
      mensaje = 'La cantidad no pudo ponerse al dia';
      _showErrorDialog(context, mensaje);
    }
  }

  Map<String, dynamic> _parseMap(String item) {
    item = item.replaceAll('{', '').replaceAll('}', '');
    List<String> partes = item.split(':');
    //
    return {partes[0].trim(): partes[1].trim()};
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exito'),
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

  //void _clearFields() {
  //  _usernameController.clear();
  //  _passwordController.clear();
  //}
}
