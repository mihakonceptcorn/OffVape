import 'package:flutter/material.dart';
import 'package:off_vape/widgets/motivation.dart';
import 'package:off_vape/widgets/progress_card.dart';
import 'package:off_vape/widgets/vape_actions.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(children: [ProgressCard(), VapeActions(), Motivation()]),
      ),
    );
  }
}
