import 'package:flutter/material.dart';

class ViewChallenges extends StatelessWidget {
  const ViewChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Challenges'),
      ),
      body: const Center(
        child: Text(
          'This is the View Challenges page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
