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
          final productIdStr = entry.key.toString();
          final int parsedId = int.tryParse(productIdStr) ?? -1;

          if (parsedId == -1) continue; // invalid ID

          final double weight = double.tryParse(entry.value.toString()) ?? 0.0;
          final double pricePer1000 = productProvider.getPrice(parsedId);

          if (pricePer1000 == 0.0) continue; // skip unknown products

          final double convertedPrice = (pricePer1000 / 1000) * weight;

          sales[productIdStr] = {
            'weight': weight,
            'price': convertedPrice,
          };
        }

        result[date] = sales;
      }

      final sortedEntries = result.entries.toList()
        ..sort(
            (a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key)));
      final sortedMap = Map.fromEntries(sortedEntries);

      setState(() {
        allProductSales = sortedMap;
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
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allProductSales.isEmpty
              ? const Center(
                  child: Text(
                    'No sales data available.',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: allProductSales.entries.map((dateEntry) {
                        final date = dateEntry.key;
                        final sales = dateEntry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.symmetric(
                                  inside: BorderSide(
                                      width: 3, color: Colors.grey.shade300),
                                  outside: BorderSide(
                                      width: 2,
                                      color: Colors.deepPurple.shade400),
                                ),
                                columnSpacing: 18,
                                dataRowMinHeight: 28,
                                dataRowMaxHeight: 38,
                                headingRowHeight: 40,
                                headingRowColor: WidgetStateProperty.all(
                                    Colors.deepPurple.shade200),
                                dataRowColor:
                                    WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return states.contains(WidgetState.selected)
                                        ? Colors.deepPurple.shade100
                                        : Colors.grey.shade100;
                                  },
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text('Product ID',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color:
                                                  Colors.deepPurple.shade900))),
                                  DataColumn(
                                      label: Text('Product Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color:
                                                  Colors.deepPurple.shade900))),
                                  DataColumn(
                                      label: Text('Weight (g)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color:
                                                  Colors.deepPurple.shade900))),
                                  DataColumn(
                                      label: Text('Sales (₹)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color:
                                                  Colors.deepPurple.shade900))),
                                ],
                                rows: sales.entries.map((entry) {
                                  final productId = entry.key;
                                  final weight = entry.value['weight'];
                                  final price = entry.value['price'];

                                  final int parsedId =
                                      int.tryParse(productId) ?? -1;
                                  final String productName = (parsedId != -1 &&
                                          parsedId <=
                                              productProvider
                                                  .productName.length)
                                      ? productProvider
                                          .productName[parsedId - 1]
                                      : 'Unknown';

                                  return DataRow(cells: [
                                    DataCell(Center(child: Text(productId))),
                                    DataCell(
                                      Row(
                                        children: [
                                          Icon(Icons.shopping_bag_outlined,
                                              color: Colors.black, size: 18),
                                          const SizedBox(width: 6),
                                          Text(productName,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade800)),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                        Text('${weight.toStringAsFixed(2)}')),
                                    DataCell(
                                        Text('₹${price.toStringAsFixed(2)}')),
                                  ]);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
