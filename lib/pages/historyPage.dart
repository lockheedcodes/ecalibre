import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecalibre/provider/calculatorProvider.dart';
import 'package:ecalibre/utils/calculatorGraph.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> dates = [];

  @override
  void initState() {
    super.initState();
    fetchDates();
  }

  Future<void> fetchDates() async {
    final provider = CalculatorProvider();
    final fetchedDates = await provider.fetchAllDates();
    setState(() {
      dates = fetchedDates;
    });
  }

  final List<Color> cardColors = [
    Color(0xFFFFF0F5),
    Color(0xFFE0FFFF),
    Color(0xFFFFF9E3),
    Color(0xFFE6E6FA),
    Color(0xFFFFF5EE),
    Color(0xFFE0F7FA),
  ];

  final List<String> tips = [
    "📈 Track your daily progress here!",
    "💡 Tip: Analyze peak activity days!",
    "🔍 Visual insights help decisions!",
    "⚙️ Plan ahead based on trends!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 155, 87, 214),
                Color.fromARGB(255, 72, 42, 132)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'A N A L Y T I C S',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 6,
      ),
      body: dates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: dates
                    .asMap()
                    .entries
                    .map((entry) => Column(
                          children: [
                            if (entry.key % 2 == 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  tips[(entry.key ~/ 2) % tips.length],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepPurple.shade700,
                                  ),
                                ),
                              ),
                            _buildGraphCard(entry.value, entry.key),
                          ],
                        ))
                    .toList(),
              ),
            ),
    );
  }

  Widget _buildGraphCard(String date, int index) {
    final color = cardColors[index % cardColors.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              ' Data for: $date',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChangeNotifierProvider(
              create: (_) => CalculatorProvider()..fetchCalculatorValues(date),
              child: const CalciGraph(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
