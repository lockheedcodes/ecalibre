import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ecalibre/provider/calculatorProvider.dart';
import 'package:ecalibre/provider/productProvider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, double> calcSales = {};
  Map<String, double> prodSales = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final calcProvider =
        Provider.of<CalculatorProvider>(context, listen: false);
    final dbRef = FirebaseDatabase.instance.ref();

    final dates = await calcProvider.fetchAllDates();
    Map<String, double> tempCalcSales = {};
    Map<String, double> tempProdSales = {};

    for (String date in dates) {
      final sum = await calcProvider.getTotalSumForDate(date);
      tempCalcSales[date] = sum;

      final prodSnap = await dbRef.child("products/$date").get();
      double prodSum = 0.0;

      if (prodSnap.exists) {
        final raw = prodSnap.value;
        Map<String, dynamic> prodData = {};

        if (raw is Map) {
          prodData = Map<String, dynamic>.from(raw);
        } else if (raw is List) {
          for (int i = 0; i < raw.length; i++) {
            final val = raw[i];
            if (val != null) {
              prodData[i.toString()] = val;
            }
          }
        }

        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        prodData.forEach((key, val) {
          final id = int.tryParse(key) ?? 0;
          final weight = double.tryParse(val.toString()) ?? 0.0;
          final rate = productProvider.getPrice(id);
          prodSum += (rate / 1000) * weight;
        });
      }

      tempProdSales[date] = prodSum;
    }

    setState(() {
      calcSales = tempCalcSales;
      prodSales = tempProdSales;
      isLoading = false;
    });
  }

  Widget buildBarChart(
      String title, Map<String, double> data, List<Color> gradientColors) {
    final dates = data.keys.toList();
    final values = data.values.map((v) => v.toDouble()).toList();
    final maxY = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1;
    final interval = (maxY / 5).ceilToDouble();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade200]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            // Wrapping in scrollable view
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: values.length * 60, // Adjusted for better spacing
              height: 280,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: maxY + interval,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '₹${rod.toY.toStringAsFixed(1)}',
                          const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, _) {
                          int index = value.toInt();
                          if (index >= 0 && index < dates.length) {
                            final dateParts = dates[index].split('-');
                            return Text("${dateParts[2]}/${dateParts[1]}",
                                style: const TextStyle(fontSize: 12));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, _) => Text(
                            "₹${value.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Removed top values
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Removed right values
                  ),
                  gridData: FlGridData(show: true, drawHorizontalLine: true),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(values.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: values[index],
                          width: 28,
                          gradient: LinearGradient(colors: gradientColors),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Sales Statistics"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 110, 77, 166)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  buildBarChart("🚀 Calculator Mode Sales", calcSales,
                      [Colors.red, Colors.orange]),
                  buildBarChart("📈 Product Mode Sales", prodSales,
                      [Colors.teal, Colors.lightBlue]),
                ],
              ),
            ),
    );
  }
}
