import 'package:ecalibre/provider/calculatorProvider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalciGraph extends StatelessWidget {
  const CalciGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Consumer<CalculatorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          } else {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.grey.shade200,
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.grey[300],
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (spot) => Colors.white,
                        tooltipRoundedRadius: 10,
                      ),
                      getTouchedSpotIndicator: (barData, spotIndexes) {
                        return spotIndexes.map((spotIndex) {
                          return TouchedSpotIndicatorData(
                            FlLine(color: Colors.deepPurple, strokeWidth: 2),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.deepPurple,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.blue, Colors.orange]),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: Colors.amber,
                              strokeColor: Colors.deepPurple,
                              strokeWidth: 2,
                            );
                          },
                        ),
                        spots: provider.chartData,
                      ),
                    ],
                    minX: 0,
                    maxX: provider.chartData.isNotEmpty
                        ? provider.chartData.length.toDouble() - 1
                        : 10,
                    minY: provider.chartData.isNotEmpty
                        ? provider.chartData
                            .map((spot) => spot.y)
                            .reduce((min, y) => min < y ? min : y)
                        : 0,
                    maxY: provider.chartData.isNotEmpty
                        ? provider.chartData
                            .map((spot) => spot.y)
                            .reduce((max, y) => max > y ? max : y)
                        : 100,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        axisNameSize: 22,
                        axisNameWidget: const Text(
                          'Rupees',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, _) {
                            if (value >= 1000) {
                              return Text(
                                  '₹${(value / 1000).toStringAsFixed(1)}k');
                            }
                            return Text('₹${value.toInt()}');
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameSize: 22,
                        axisNameWidget: const Text(
                          'Sales',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            return Text('${(value + 1).toInt()}');
                          },
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
