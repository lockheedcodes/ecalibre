import 'package:ecalibre/pages/loginPage.dart';
import 'package:ecalibre/pages/productFile.dart';
import 'package:ecalibre/pages/statistics.dart';
import 'package:ecalibre/pages/voicePage.dart';
import 'package:ecalibre/provider/calculatorProvider.dart';
import 'package:ecalibre/provider/productProvider.dart';
import 'package:ecalibre/utils/actions.dart';
import 'package:ecalibre/utils/addProduct.dart';
import 'package:ecalibre/utils/calculatorGraph.dart';

import 'package:ecalibre/utils/smallWidgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CalculatorMode extends StatelessWidget {
  CalculatorMode({super.key});
  DateTime now = DateTime.now();
  late String formattedDate = DateFormat('yyyy-MM-dd').format(now);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'User';
    final username = email.contains('@') ? email.split('@')[0] : email;

    return Container(
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
        child: Column(
          children: [
            _buildHeader(context, username),
            _buildSalesCard(context),
            _buildSalesDateDisplay(),
            _buildGraphForDate(formattedDate),
            _buildInsightsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String username) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 10, right: 10.0),
      child: Row(children: [
        CircleAvatar(
            radius: 32, backgroundImage: AssetImage('assets/images/boy.png')),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back!',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700)),
            Text(username,
                style: TextStyle(fontSize: 18, fontFamily: 'Poppins')),
          ],
        ),
        Spacer(),
        IconButton(
            icon: Icon(Icons.logout_rounded, size: 25),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Loginpage()));
            }),
        IconButton(
            icon: Icon(Icons.settings, size: 25),
            onPressed: () => showInventoryDialog(context)),
      ]),
    );
  }

  Widget _buildSalesCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 10, right: 10.0),
      child: Card(
        color: const Color.fromARGB(255, 145, 160, 234),
        child: Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Today's Sales ",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 19)),
            FutureBuilder<double>(
              future: Provider.of<CalculatorProvider>(context, listen: false)
                  .getTotalSumForDate(formattedDate.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                else if (snapshot.hasError) return Text("Error fetching total");
                final total = snapshot.data ?? 0.0;
                return Text('₹${total.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 25));
              },
            ),
            SizedBox(height: 10),
            Text("Calculating Options :",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 19,
                    fontStyle: FontStyle.italic)),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _buildOption(
                  context,
                  'assets/images/voice.svg',
                  'VoiceBill',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VoicePage()))),
              _buildOption(
                  context,
                  'assets/images/inventory.svg',
                  'Products',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductFile()))),
              _buildOption(
                  context,
                  'assets/images/stats.svg',
                  'Statistics',
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatisticsPage()))),
              _buildOption(context, 'assets/images/edit.svg', 'Edit Prices',
                  () => editPrice(context)),
            ]),
            SizedBox(height: 15),
            _buildAddButton(context),
          ]),
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, String asset, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: OptionsWidget(pictureAsset: asset, action: label),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      color: const Color.fromARGB(255, 5, 73, 129),
      onPressed: () => addProduct(context),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.add_box, color: Colors.white),
        SizedBox(width: 10),
        Text('Add Product',
            style: TextStyle(
                fontFamily: 'Roboto', fontSize: 15, color: Colors.white))
      ]),
    );
  }

  Widget _buildSalesDateDisplay() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Total Sales on',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.grey[700])),
        Text(formattedDate,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.grey[700])),
      ]),
    );
  }

  Widget _buildChartSection(String title, Widget chartWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left),
        SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: chartWidget),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInsightsCard(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref();

    return Padding(
      padding: EdgeInsets.all(15),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color.fromARGB(255, 212, 175, 246),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📊 Business Insights",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Divider(thickness: 1.5),
              FutureBuilder<DataSnapshot>(
                future: databaseRef
                    .child('calculator_inventory/$formattedDate/inventoryPrice')
                    .get(),
                builder: (context, inventorySnapshot) {
                  if (inventorySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (inventorySnapshot.hasError) {
                    return Center(
                        child: Text("⚠️ Error fetching inventory data",
                            style: TextStyle(color: Colors.red)));
                  }

                  double inventory =
                      (inventorySnapshot.data?.value as num?)?.toDouble() ?? 0;

                  return FutureBuilder<Map<String, double>>(
                    future:
                        Provider.of<CalculatorProvider>(context, listen: true)
                            .getInsightsData(formattedDate),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("⚠️ Error fetching sales data",
                                style: TextStyle(color: Colors.red)));
                      }

                      final data = snapshot.data ?? {};
                      final totalSales = data['totalSales'] ?? 0;
                      final profitPercent = totalSales >= inventory
                          ? (((totalSales - inventory) / inventory) * 100)
                          : 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _insightLine1('💰 Inventory Value', inventory),
                          _insightLine1('📈 Total Sales', totalSales),
                          _insightLine1('🏆 Best Earnings', data['maxIncome']),
                          _insightLine1('⚡ Lowest Earnings', data['minIncome']),
                          _insightLine1(
                              '📊 Average Earnings', data['avgIncome']),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: Text(
                              '📈 Profit Percentage: ${profitPercent.toStringAsFixed(2)}%',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _insightLine1(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            value != null ? '₹${value.toStringAsFixed(2)}' : 'N/A',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _insightLine(String label, double? value) {
    return Text('$label: ₹${value?.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  void showInventoryDialog(BuildContext context) {
    final inventoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Inventory Price'),
          content: TextField(
            controller: inventoryController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Inventory Price'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            TextButton(
              onPressed: () async {
                double inventoryPrice =
                    double.tryParse(inventoryController.text) ?? 0.0;
                final provider =
                    Provider.of<CalculatorProvider>(context, listen: false);
                await provider.saveInventoryPrice(
                    formattedDate, inventoryPrice);
                await provider.getInsightsData(formattedDate);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGraphForDate(String date) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ChangeNotifierProvider(
        create: (_) => CalculatorProvider()..fetchCalculatorValues(date),
        child: CalciGraph(),
      ),
    );
  }
}
