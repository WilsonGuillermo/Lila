import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tienda/modelos/categoria.dart';
import 'package:tienda/modelos/producto.dart';
import 'package:tienda/Transverso/parametros.dart';

class ApiServicios {
  // Recuperacion parametros backend
  String url = Parametros.direccionBackend_new;
  int puerto = Parametros.puerto_new;

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$url:$puerto/categorias'));
    print("----------1-----");
    if (response.statusCode == 200) {
      print("----------2-----");
      List<dynamic> data = json.decode(response.body);
      print('lista es $data');
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('No podemos cargar los productos por categoria');
    }
  }

  // Método para obtener productos por categoria
  Future<List<Product>> getProductsByCategory( int categoryId ) async {
    print("----------3-----");
    final response = await http.get(Uri.parse('$url:$puerto/productos_par_categoria?category_id=$categoryId'));
    if (response.statusCode == 200) {
      print("----------4-----");
      List<dynamic> data = json.decode(response.body);
      print('los productos son $data');
      data.forEach((item) {print(item['imagen']);});
      print('los productos en getProductsByCategory son: $data');
      return data.map((json) => Product.fromJson(_trasnformacionJson(json))).toList();
    } else {
      throw Exception('No podemos cargar los productos por categoria');
    }
  }

  // Método para obtener productos por categoria
  Future<List<Product>> obtenerProductosEnSaldos( int categoryId ) async {
    print("----------3-----");
    final response = await http.get(Uri.parse('$url:$puerto/productos_par_categoria?category_id=$categoryId'));
    if (response.statusCode == 200) {
      print("----------4-----");
      List<dynamic> data = json.decode(response.body);
      print('los productos son $data');
      data.forEach((item) {print(item['imagen']);});
      print('los productos en getProductsByCategory son: $data');
      return data.map((json) => Product.fromJson(_trasnformacionJson(json))).toList();
    } else {
      throw Exception('No podemos cargar los productos por categoria');
    }
  }

  // Método para obtener productos por tipo
  Future<List<Product>> getProductsByTipo( String tipo, int categoryId ) async {
    print("----------3-----");

    final response = await http.post(
      Uri.parse('$url:$puerto/productos_par_tipo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tipo': tipo,
        'category_id': categoryId.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print("----------44-----");
      List<dynamic> data = json.decode(response.body);
      print('los productos por tipo son $data');
      //data.forEach((item) {print(item['imagen']);});
      print('los productos en getProductsByTipo son: $data');
      return data.map((json) => Product.fromJson(_trasnformacionJson(json))).toList();
    } else {
      throw Exception('No podemos cargar los productos por tipo');
    }
  }

  Future<List<Product>> getProducts() async {
    print("----------5-----");
    final response = await http.get(Uri.parse('$url:$puerto/productos'));
    if (response.statusCode == 200) {
      print("----------6-----");
      List<dynamic> data = json.decode(response.body);
      print("----------7-----");
      print('los productos en getProducts son $data');
      data.forEach((item) {print(item['imagen']);});
      return data.map((json) => Product.fromJson(_trasnformacionJson(json))).toList();
    } else {
      throw Exception('No podemos cargar los productos en getProducts');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$url:$puerto/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'size': product.size,
        'color': product.color,
        'stock': product.stock,
        'imagen': product.imagen,
        'tipo': product.tipo,
        'referencia': product.referencia,
        'estilo': product.estilo,
        'corte': product.corte,
      }),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$url:$puerto/products/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'size': product.size,
        'color': product.color,
        'stock': product.stock,
        'imagen': product.imagen,
        'tipo': product.tipo,
        'referencia': product.referencia,
        'estilo': product.estilo,
        'corte': product.corte,
      }),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$url:$puerto/products/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
    return response.statusCode == 200;
  }

  Map<String, dynamic> _trasnformacionJson(Map<String, dynamic> json ) {
    //print('por aqui pase...');
    return {
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
      'price': json['price'],
      'categoryId': json['categoryId'],
      'size': json['size'],
      'color': json['color'],
      'stock': json['stock'],
      'imagen': json['imagen'],
      'tipo': json['tipo'],
      'referencia': json['referencia'],
      'estilo': json['estilo'],
      'corte': json['corte'],

    };
  }

}
