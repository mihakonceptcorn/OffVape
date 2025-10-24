import 'package:flutter/material.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
      child: Card(
        elevation: 4.0,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Text('Chart'),
      ),
    );
  }
}
