import 'package:flutter/material.dart';

class SchedulingScreen extends StatelessWidget {
  const SchedulingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        centerTitle: true,
      ),
      body: const SchedulingContent(),
    );
  }
}

// Content-only version for use with BottomNavWrapper
class SchedulingContent extends StatelessWidget {
  const SchedulingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Medication Schedules',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your medication schedules',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
