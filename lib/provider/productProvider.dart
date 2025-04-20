import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final List<int> productId = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<String> productName = [
    'Apple',
    'Orange',
    'Carrot',
    'Beetroot',
    'Raddish',
    'Pumpkin',
    'Beans',
    'Tomatoe',
    'Potatoe',
    'Onion'
  ];
  final List<int> productPrice = [350, 200, 70, 60, 30, 50, 100, 40, 60, 40];

  List<Product> get products => List.generate(productId.length, (index) {
        return Product(
          id: productId[index],
          name: productName[index].toLowerCase(),
          price: productPrice[index].toDouble(),
        );
      });

  void updateProduct(int id, int newPrice) {
    final index = productId.indexOf(id);
    if (index != -1) {
      productPrice[index] = newPrice;
      notifyListeners();
    }
  }

  void addNewProduct(int id, int price, String name) {
    productId.add(id);
    productName.add(name);
    productPrice.add(price);
    notifyListeners();
  }

  double getPrice(int productId) {
    return (productPrice[productId - 1]).toDouble();
  }
}

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}
