import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_vape/providers/vaping_breaks_provider.dart';
import 'package:off_vape/providers/user_settings_provider.dart';
import 'package:off_vape/models/break.dart';
import 'package:off_vape/l10n/app_localizations.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() {
    return _StatisticsScreenState();
  }
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  late List<Break> _breaks;
  late List<Break> _vapeBreaks;
  late List<Break> _exerciseBreaks;
  bool _isLoading = true;
  int _period = 7;

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  final String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    super.initState();
    loadInitialData();

    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId, // заміниш на свій ID після релізу
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, err) {
          debugPrint('Ad failed to load: ${err.message}');
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  void loadInitialData() async {
    final data = await getBreaksByDays(_period);

    setState(() {
      _breaks = data;
      _vapeBreaks = _breaks.where((b) => b.type == BreakType.inhale).toList();
      _exerciseBreaks = _breaks
          .where((b) => b.type == BreakType.exercise)
          .toList();

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
        _exerciseBreaks = _breaks
            .where((b) => b.type == BreakType.exercise)
            .toList();
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Period changed to $selectedPeriod')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final List<int> dailyVapeCounts = List.filled(_period, 0);
    final List<int> dailyExerciseCounts = List.filled(_period, 0);

    for (final vapeBreak in _vapeBreaks) {
      final date = DateTime(
        vapeBreak.timestamp.year,
        vapeBreak.timestamp.month,
        vapeBreak.timestamp.day,
      );

      final diff = today.difference(date).inDays;

      if (diff >= 1 && diff <= _period) {
        dailyVapeCounts[_period - diff]++;
      }
    }

    for (final exerciseBreak in _exerciseBreaks) {
      final date = DateTime(
        exerciseBreak.timestamp.year,
        exerciseBreak.timestamp.month,
        exerciseBreak.timestamp.day,
      );

      final diff = today.difference(date).inDays;

      if (diff >= 1 && diff <= _period) {
        dailyExerciseCounts[_period - diff]++;
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
            child: Localizations.override(
              context: context,
              locale: Locale(settings.languageCode),
              child: Builder(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.statsTitle,
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
                                AppLocalizations.of(
                                  context,
                                )!.statsTitleSub(_period),
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                        child: Text(AppLocalizations.of(context)!.statsChange),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.statsTitleExercise(_period),
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
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
                                          in dailyExerciseCounts) // alternative to map()
                                        BarChartGroupData(
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                              toY: count.toDouble(),
                                              color: Colors.green[200],
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
                      const SizedBox(height: 32),
                      if (_isAdLoaded)
                        SizedBox(
                          height: _bannerAd.size.height.toDouble(),
                          width: _bannerAd.size.width.toDouble(),
                          child: AdWidget(ad: _bannerAd),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
