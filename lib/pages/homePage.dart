import 'package:ecalibre/pages/calculatorMode.dart';
import 'package:ecalibre/pages/historyPage.dart';
import 'package:ecalibre/pages/productMode.dart';
import 'package:ecalibre/provider/pageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PageProvider>(context);
    final List<Widget> pages = [
      CalculatorMode(),
      ProductModePage(),
      HistoryPage()
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: pages[provider.pageIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Transparent background
        color: const Color.fromARGB(255, 157, 141, 199), // Light purple shade
        height: 70,
        items: [
          Column(
            children: [
              Icon(Icons.home, size: 28, color: Colors.black), // Home icon
              Text('Home', style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.shopping_cart,
                  size: 28, color: Colors.black), // Product icon
              Text('Products',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.history,
                  size: 28, color: Colors.black), // History icon
              Text('History',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
        ],
        onTap: (index) {
          provider.setIndex(index);
        },
        index: provider.pageIndex,
        animationDuration: Duration(milliseconds: 400), // Animation duration
        animationCurve: Curves.easeInOut, // Smooth animation curve
      ),
    );
  }
}
