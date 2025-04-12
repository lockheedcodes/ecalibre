import 'package:ecalibre/provider/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFile extends StatelessWidget {
  const ProductFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Product Table',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.topRight,
                colors: [
                  const Color.fromARGB(255, 205, 192, 240),
                  const Color.fromARGB(255, 183, 238, 233),
                  const Color.fromARGB(255, 205, 192, 240),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.all(color: Colors.teal, width: 2),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        // Table Header
                        TableRow(
                          decoration: BoxDecoration(color: Colors.tealAccent),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'PRODUCT ID',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ITEM',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'PRICE IN RS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Table Rows
                        for (int i = 0;
                            i < productProvider.productId.length;
                            i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color:
                                  i % 2 == 0 ? Colors.teal[50] : Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productProvider.productId[i].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productProvider.productName[i],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productProvider.productPrice[i].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
