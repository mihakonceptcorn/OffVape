import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

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
      body: const Column(
        children: [
          Text('User Zone'),
        ],
      ),
    );
  }
}