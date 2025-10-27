import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_vape/providers/vaping_breaks_provider.dart';
import 'package:off_vape/providers/user_settings_provider.dart';

import 'package:off_vape/models/break.dart';

import 'package:off_vape/l10n/app_localizations.dart';

class ProgressCard extends ConsumerStatefulWidget {
  const ProgressCard({super.key});

  @override
  ConsumerState<ProgressCard> createState() {
    return _ProgressCardState();
  }
}

class _ProgressCardState extends ConsumerState<ProgressCard> {
  @override
  void initState() {
    super.initState();
    ref.read(vapingBreaksProvider.notifier).getCurrentBreaks();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    final currentBreaks = ref.watch(vapingBreaksProvider);
    final currentVapeBreaks = currentBreaks.where((b) => b.type == BreakType.inhale).toList();
    final currentExersizeBreaks = currentBreaks.where((b) => b.type == BreakType.exercise).toList();

    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Localizations.override(
            context: context,
            locale: const Locale('uk'),
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: CircularProgressIndicator(
                                  value: currentVapeBreaks.length <= settings.dailyLimit
                                      ? currentVapeBreaks.length / settings.dailyLimit
                                      : 1,
                                  strokeWidth: 20,
                                  color: currentVapeBreaks.length <= settings.dailyLimit
                                      ? Colors.blueAccent
                                      : Colors.red,
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    216,
                                    215,
                                    215,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${currentVapeBreaks.length} VapeBreaks of ${settings.dailyLimit}',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.titleLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            fontWeight: FontWeight.bold
                                          ),
                                    ),
                                    const SizedBox(height: 8,),
                                    Text(
                                      '15 min ago',
                                      style: Theme.of(context).textTheme.bodyLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
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
                    Text(
                      '${currentExersizeBreaks.length} Substitutes today',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
