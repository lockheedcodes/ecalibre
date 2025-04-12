import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class CalculatorProvider with ChangeNotifier {
  List<FlSpot> _chartData = [];
  bool _isLoading = false;
  String? _error;
  final dbRef = FirebaseDatabase.instance.ref();
  double _totalSum = 0;

  List<FlSpot> get chartData => _chartData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get totalSum => _totalSum;

  void reset() {
    _chartData.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  Future<void> fetchCalculatorValues(String date) async {
    _isLoading = true;
    _error = null;
    _chartData.clear();
    notifyListeners();

    try {
      final snapshot = await dbRef.child('calculator/$date').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final values = data.values.whereType<int>().toList();

        _chartData = List.generate(values.length, (index) {
          final value = values[index].toDouble();
          return FlSpot(
              index.toDouble(), value.isNaN || value.isInfinite ? 0.0 : value);
        });

        _totalSum = _chartData.fold(0.0, (sum, spot) => sum + spot.y);
      } else {
        _chartData = [];
        _totalSum = 0;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> fetchAllDates() async {
    final snapshot = await dbRef.child('calculator').get();
    if (snapshot.exists) {
      return (snapshot.children.map((e) => e.key).whereType<String>()).toList();
    } else {
      return [];
    }
  }

  Future<double> getTotalSumForDate(String date) async {
    try {
      final snapshot = await dbRef.child('calculator/$date').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final values = data.values.whereType<num>().toList();
        final sum = values.fold(0.0, (prev, el) => prev + el.toDouble());
        return sum;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}
