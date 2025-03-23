import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:tienda/Transverso/parametros.dart';

class ProductosPdfPage extends StatelessWidget {
  final List<dynamic> productos;

  List<List<dynamic>> ProductosList = [];

  ProductosPdfPage(this.productos);

  String path_appli = Parametros.path_appli;

  Future<void> _generarPDF(BuildContext context) async {
    final pdf = pdfLib.Document();

    ProductosList = crearListaProductos(productos);

    print('"""""""""""""Lista de Productos"""""""""""');
    print(ProductosList);

    // Crear tabla
    final table = pdfLib.TableHelper.fromTextArray(
      //headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headers: ['Producto', 'Cantidad'],
      data: ProductosList,
    );

    // Agregar tabla al PDF
    pdf.addPage(pdfLib.Page(build: (context) => table));

    // Guardar PDF en el dispositivo
    final bytes = await pdf.save();

    // Obtener la date actual
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month}-${now.day}';

    // Aquí deberías implementar la lógica para guardar el PDF donde desees
    // Obtener el directorio de documentos del dispositivo
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/productos_$formattedDate.pdf';
    //final path = path_appli/productos_$formattedDate.pdf';
    print("directorio");
    print(path);

    // Escribir el archivo PDF en el directorio de documentos
    final file = File(path);
    await file.writeAsBytes(bytes);

    print('PDF guardado en: $path');

    // Abrir el PDF utilizando url_launcher
    final url = 'data:application/pdf;base64,' + base64Encode(bytes);

    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print('No se puede abrir el PDF: $e');
    }

    print('PDF generado y guardado correctamente');

    String mensaje = 'PDF generado y guardado aqui: $path';
    _showPdfGuardadoDialog(context, mensaje);
  }

  List<List<dynamic>> crearListaProductos(List<dynamic> listaOriginal) {
    List<List<dynamic>> listaProductos = [];

    List<dynamic> ListaConComillas = listaOriginal;

    print('iiiiiiiiiiiiii lista original iiiiiiiiiiiii');
    print(ListaConComillas);

    List<List<dynamic>> ListaDividida = [];

    for (int i = 0; i < ListaConComillas.length; i += 2) {
      print('-----------------i es ----------');
      print(i);
      if (i < (ListaConComillas.length - 2)) {
        ListaDividida.add([ListaConComillas[i], ListaConComillas[i + 1]]);
      }
    }

    print('iiiiiiiiiiiiii lista modificada iiiiiiiiiiiii');
    print(ListaDividida);

    for (List<dynamic> subLista in listaOriginal) {
      List<dynamic> nuevaSubLista = [];
      for (String elemento in subLista) {
        nuevaSubLista
            .add("'$elemento'"); // Agregamos comillas simples a cada elemento
      }

      listaProductos.add(nuevaSubLista);
    }

    //return ListaDividida;
    return listaProductos;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabla de productos
        Expanded(
          child: ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(productos[index][0]), // Producto
                subtitle: Text(productos[index][1]), // Cantidad
              );
            },
          ),
        ),
        // Botón para generar PDF
        ElevatedButton(
          onPressed: () {
            _generarPDF(context);
          },
          child: const Text('Generar PDF'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
    //);
  }

  void _showPdfGuardadoDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
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
