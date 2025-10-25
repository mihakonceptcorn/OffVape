import 'package:flutter/material.dart';

import 'package:off_vape/local_storage/user_settings.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? _language;
  int? _limit;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    final lang = await UserSettings.getLanguage();
    final limit = await UserSettings.getDailyLimit();

    setState(() {
      _language = lang;
      _limit = limit;
    });
  }

  Future<void> showLanguageDialog(BuildContext context) async {
    final languages = ['en', 'ua'];
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
                onTap: () => Navigator.pop(context, lang),
              ),
            )
            .toList(),
      ),
    );

    if (selectedLanguage != null) {
      await UserSettings.setLanguage(selectedLanguage);
      setState(() {
        _language = selectedLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OffVape',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            Colors.black54, // Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart_sharp)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Language:',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Text(
                          '$_language',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Maximum vape breaks per day:',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Text(
                          '$_limit',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => showLanguageDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          child: const Text('Change language'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          child: const Text('Change MaxBreaks'),
                        ),
                      ],
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
