import 'package:flutter/material.dart';

import 'package:off_vape/widgets/home_stats.dart';
import 'package:off_vape/widgets/motivation.dart';
import 'package:off_vape/widgets/progress_card.dart';
import 'package:off_vape/widgets/vape_actions.dart';
import 'package:off_vape/providers/vaping_breaks_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          IconButton(
            onPressed: () {
              clearTable();
            },
            icon: const Icon(Icons.delete_forever),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart_sharp)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProgressCard(),
            VapeActions(),
            Motivation(),
            HomeStats(),
          ],
        ),
      ),
    );
  }
}
