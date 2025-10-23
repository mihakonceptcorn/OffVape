import 'package:flutter/material.dart';
import 'package:off_vape/widgets/progress_card.dart';
import 'package:off_vape/widgets/vape_actions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OffVape'),
        backgroundColor: Colors.black54,// Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline)
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProgressCard(),
            VapeActions(),
          ],
        ),
      ),
    );
  }
}