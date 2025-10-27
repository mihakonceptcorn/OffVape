import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import 'package:off_vape/providers/user_settings_provider.dart';
import 'package:off_vape/providers/vaping_breaks_provider.dart';
import 'package:off_vape/l10n/app_localizations.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(settingsProvider.notifier);
    final languages = ['en', 'uk'];

    final String? selectedLanguage = await showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: languages
            .map(
              (lang) => ListTile(
                title: Text(lang),
                shape: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context, lang);
                },
              ),
            )
            .toList(),
      ),
    );

    if (selectedLanguage != null) {
      await notifier.updateLanguage(selectedLanguage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Language changed to $selectedLanguage')),
      );
    }
  }

  Future<void> _showLimitDialog(
    BuildContext context,
    WidgetRef ref,
    int currentLimit,
  ) async {
    final notifier = ref.read(settingsProvider.notifier);
    final TextEditingController controller = TextEditingController(
      text: currentLimit.toString(),
    );

    final int? selectedLimit = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Set Daily Limit',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Daily limit (number of vape breaks)',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();

                  final newLimit = int.tryParse(controller.text);
                  if (newLimit == null || newLimit <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, newLimit);
                },
                icon: const Icon(Icons.check),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    if (selectedLimit != null) {
      await notifier.updateLimit(selectedLimit);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Daily limit updated to $selectedLimit')),
      );
    }
  }

  Future<void> _showRemovePopup(BuildContext context) async {
    final isConfirm = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CupertinoAlertDialog(
              title: const Text('Clear all data?'),
              content: const Text('This action will permanently delete all your session history and reset your progress. Are you sure you want to continue?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Delete all'),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context, true);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
        );
      },
    );

    if (isConfirm) {
      clearTable();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

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
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Localizations.override(
                  context: context,
                  locale: Locale(settings.languageCode),
                  child: Builder(
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Language ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.language,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                              Text(
                                settings.languageCode,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),

                          // --- Limit ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.userMaxNum,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                              Text(
                                settings.dailyLimit.toString(),
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 32),

                          // --- Buttons ---
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.remove_circle_outline),
                                label: Text(AppLocalizations.of(context)!.clearAll,),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.errorContainer,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                ),
                                onPressed: () {
                                  HapticFeedback.heavyImpact();
                                  _showRemovePopup(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _showLanguageDialog(context, ref);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                                child: Text(AppLocalizations.of(context)!.changeLanguage),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _showLimitDialog(context, ref, settings.dailyLimit);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                                child: Text(AppLocalizations.of(context)!.changeMaxBreaks),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
