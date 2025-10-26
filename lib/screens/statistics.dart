import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:off_vape/providers/vaping_breaks_provider.dart';
import 'package:off_vape/models/break.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() {
    return _StatisticsScreenState();
  }
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late List<Break> _breaks;
  late List<Break> _vapeBreaks;
  bool _isLoading = true;
  int _period = 7;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() async {
    final data = await getBreaksByDays(_period);

    setState(() {
      _breaks = data;
      _vapeBreaks = _breaks.where((b) => b.type == BreakType.inhale).toList();

      _isLoading = false;
    });
  }

  Future<void> showPeriodDialog(BuildContext context) async {
    final periods = ['7', '30', '90', '180', '365'];

    final String? selectedPeriod = await showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: periods
            .map(
              (days) => ListTile(
                title: Text(days),
                shape: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context, days);
                },
              ),
            )
            .toList(),
      ),
    );

    if (selectedPeriod != null) {
      setState(() {
        _isLoading = true;
        _period = int.parse(selectedPeriod);
      });
      final data = await getBreaksByDays(_period);

      setState(() {
        _breaks = data;
        _vapeBreaks = _breaks.where((b) => b.type == BreakType.inhale).toList();

        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Period changed to $selectedPeriod')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final now = DateTime.now();
    final List<int> dailyVapeCounts = List.filled(_period, 0);

    for (final vapeBreak in _vapeBreaks) {
      final diff = now.difference(vapeBreak.timestamp).inDays;
      if (diff >= 1 && diff <= _period) {
        dailyVapeCounts[_period - diff]++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OffVape',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'VapeBreaks for the past $_period days.',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              gridData: const FlGridData(show: true),
                              barGroups: [
                                for (final count
                                    in dailyVapeCounts) // alternative to map()
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(
                                        toY: count.toDouble(),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            showPeriodDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          child: const Text('Change period'),
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
