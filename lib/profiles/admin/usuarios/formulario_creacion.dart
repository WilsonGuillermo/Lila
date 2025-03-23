import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tienda/profiles/admin/PaginaUsuariosAdmin.dart';

void main() {
  runApp(MiFormulario());
}

class MiFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Registro'),
        ),
        body: WebView(
          initialUrl: 'asset://assets/formulario_registro.html',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
