import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:off_vape/providers/vaping_breaks_provider.dart';
import 'package:off_vape/models/break.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({super.key});

  Future<List<Break>> _loadBreaks() async {
    final breaks = await getBreaksByDays(7);
    return breaks;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadBreaks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Error loading chart');
        } else if (!snapshot.hasData) {
          return const Text('No data found');
        }

        final data = snapshot.data!;
        final breaks = data.where((b) => b.type == BreakType.inhale);

        final now = DateTime.now();
        final List<int> dailyCounts = List.filled(7, 0);

        for (final vapeBreak in breaks) {
          final diff = now.difference(vapeBreak.timestamp).inDays;
          if (diff >= 1 && diff <= 7) {
            dailyCounts[7 - diff]++;
          }
        }

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
                                  toY: dailyCounts[0].toDouble(),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyCounts[1].toDouble(),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyCounts[2].toDouble(),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyCounts[3].toDouble(),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyCounts[4].toDouble(),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyCounts[5].toDouble(),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyCounts[6].toDouble(),
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
    );
  }
}
