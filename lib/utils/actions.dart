import 'package:ecalibre/provider/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void editPrice(BuildContext context) {
  final TextEditingController idController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Update Product',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Product ID',
                  labelStyle: TextStyle(fontFamily: 'Roboto'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'New Price',
                  labelStyle: TextStyle(fontFamily: 'Roboto'),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(
                'Change',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onPressed: () {
                if (idController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .updateProduct(int.parse(idController.text),
                          int.parse(priceController.text));
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
