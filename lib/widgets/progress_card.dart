import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_vape/providers/vaping_breaks_provider.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBreaks = ref.watch(vapingBreaksProvider);
    final maxDayVapeBreaks = 20;

    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                            value: currentBreaks.vapeBreaks <= maxDayVapeBreaks
                                ? currentBreaks.vapeBreaks / maxDayVapeBreaks
                                : 1,
                            strokeWidth: 20,
                            color: currentBreaks.vapeBreaks <= maxDayVapeBreaks
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
                                '${currentBreaks.vapeBreaks} VapeBreaks of $maxDayVapeBreaks',
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
                '${currentBreaks.substitutes} Substitutes today',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
