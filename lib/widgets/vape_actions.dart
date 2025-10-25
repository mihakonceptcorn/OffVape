import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_vape/data/substitutes.dart';
import 'package:off_vape/models/substitute.dart';
import 'package:off_vape/providers/vaping_breaks_provider.dart';

class VapeActions extends ConsumerStatefulWidget {
  const VapeActions({super.key});

  @override
  ConsumerState<VapeActions> createState() {
    return _VapeActionsState();
  }
}

class _VapeActionsState extends ConsumerState<VapeActions> {
  Substitute? _selectedSubstitute;

  Future showSubstitutePopup(BuildContext context) async {
    final isDone = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CupertinoAlertDialog(
              title: Text(_selectedSubstitute!.title),
              content: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset(_selectedSubstitute!.imageSrc),
                  ),
                ],
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Reject'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
        );
      },
    );

    if (isDone) {
      ref.read(vapingBreaksProvider.notifier).addSubstitute(_selectedSubstitute!.title);
    }

    _selectedSubstitute = null;
  }

  Future<void> showSubstituteDialog(BuildContext context) async {
    final Substitute? selected = await showModalBottomSheet<Substitute>(
      context: context,
      builder: (context) => ListView(
        children: substitutes
            .map(
              (s) => ListTile(
                title: Text(s.title),
                onTap: () => Navigator.pop(context, s),
              ),
            )
            .toList(),
      ),
    );

    if (selected != null && context.mounted) {
      _selectedSubstitute = selected;
      showSubstitutePopup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart_sharp),
                label: const Text('Statistics'),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.smoking_rooms),
                label: Text(
                  '+ Vape Break',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer,
                ),
                onPressed: () {
                  ref.read(vapingBreaksProvider.notifier).addVapeBreak();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.fitness_center),
            label: const Text('Quick exercise instead of vaping'),
            onPressed: () => showSubstituteDialog(context),
          ),
        ],
      ),
    );
  }
}
