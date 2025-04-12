import 'package:ecalibre/pages/calculatorMode.dart';
import 'package:ecalibre/pages/historyPage.dart';
import 'package:ecalibre/pages/productMode.dart';
import 'package:ecalibre/provider/pageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.transparent,
        body: pages[provider.pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlueAccent,
          onTap: (index) {
            provider.setIndex(index);
          },
          currentIndex: provider.pageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Calculator'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Products'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'History'),
          ],
        ));
  }
}
