import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_vape/data/motivation_texts.dart';
import 'package:off_vape/data/motivation_texts_uk.dart';
import 'package:off_vape/providers/user_settings_provider.dart';

class Motivation extends ConsumerWidget {
  const Motivation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    Random random = Random();

    var localMotivationTexts = motivationTexts;
    if (settings.languageCode == 'uk') {
      localMotivationTexts = motivationTextsUk;
    }

    int randomIndex = random.nextInt(localMotivationTexts.length);
    final motivationText = localMotivationTexts[randomIndex];



    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
      child: SizedBox(
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
    );
  }
}
