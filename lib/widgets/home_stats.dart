import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4.0,
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 32,
              right: 32,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.bar_chart_sharp,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Statistics for the last 7 days.',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      gridData: const FlGridData(show: true),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: 7,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: 6,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: 3,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: 5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              toY: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
