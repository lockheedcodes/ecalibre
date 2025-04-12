import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:ecalibre/provider/productProvider.dart';

class ProductModePage extends StatefulWidget {
  const ProductModePage({super.key});

  @override
  State<ProductModePage> createState() => _ProductModePageState();
}

class _ProductModePageState extends State<ProductModePage> {
  Map<String, Map<String, dynamic>> allProductSales = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllProductData();
  }

  Future<void> fetchAllProductData() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final snapshot = await dbRef.child('products').get();
    if (snapshot.exists) {
      final datesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final Map<String, Map<String, dynamic>> result = {};

      for (var dateEntry in datesMap.entries) {
        final date = dateEntry.key;
        final productEntries = dateEntry.value;

        Map<String, dynamic> productMap;
        if (productEntries is Map) {
          productMap = Map<String, dynamic>.from(productEntries);
        } else if (productEntries is List) {
          productMap = {
            for (int i = 0; i < productEntries.length; i++)
              if (productEntries[i] != null) i.toString(): productEntries[i]
          };
        } else {
          continue;
        }

        final Map<String, dynamic> sales = {};

        for (var entry in productMap.entries) {
          final productId = entry.key.toString();
          final weight = double.tryParse(entry.value.toString()) ?? 0.0;
          final pricePer1000 =
              productProvider.getPrice(int.tryParse(productId) ?? 0);
          final convertedPrice = (pricePer1000 / 1000) * weight;

          sales[productId] = {
            'weight': weight,
            'price': convertedPrice,
          };
        }

        result[date] = sales;
      }

      setState(() {
        allProductSales = result;
        isLoading = false;
      });
    } else {
      setState(() {
        allProductSales = {};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Sales Summary"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allProductSales.isEmpty
              ? const Center(child: Text('No sales data available.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allProductSales.length,
                  itemBuilder: (context, dateIndex) {
                    final date = allProductSales.keys.elementAt(dateIndex);
                    final sales = allProductSales[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...sales.entries.map((entry) {
                          final productId = entry.key;
                          final weight = entry.value['weight'];
                          final price = entry.value['price'];

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            color: Colors
                                .primaries[int.parse(productId) %
                                    Colors.primaries.length]
                                .shade100,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(
                                'Product ID: $productId  ${productProvider.productName[int.parse(productId) - 1]}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                style: TextStyle(fontSize: 17),
                                'Weight: ${weight.toStringAsFixed(2)}g\nSales: ₹${price.toStringAsFixed(2)}',
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
    );
  }
}
