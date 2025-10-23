import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_vape/data/motivation_texts.dart';
import 'package:off_vape/data/substitutes.dart';
import 'package:off_vape/providers/vaping_breaks_provider.dart';

class VapeActions extends ConsumerWidget {
  const VapeActions({super.key});

  Future<void> showSubstituteDialog(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => ListView(
        children: substitutes
            .map(
              (s) => ListTile(
                title: Text(s),
                onTap: () => Navigator.pop(context, s),
              ),
            )
            .toList(),
      ),
    );

    if (selected != null) {
      // saveSubstitute(selected);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Random random = Random();
    int randomIndex = random.nextInt(motivationTexts.length);
    final motivationText = motivationTexts[randomIndex];

    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.smoking_rooms),
              label: Text(
                '+ Vape Break',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer,
              ),
              onPressed: () {
                ref.read(vapingBreaksProvider.notifier).addVapeBreak();
              },
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.fitness_center),
              label: const Text('Quick exercise instead of vaping'),
              onPressed: () => showSubstituteDialog(context),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart_sharp),
              label: const Text('Statistics'),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 4.0,
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Icon(
                        Icons.info_outline,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        motivationText,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
