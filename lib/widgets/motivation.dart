import 'dart:math';
import 'package:flutter/material.dart';

import 'package:off_vape/data/motivation_texts.dart';

class Motivation extends StatelessWidget {
  const Motivation({super.key});

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int randomIndex = random.nextInt(motivationTexts.length);
    final motivationText = motivationTexts[randomIndex];

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
