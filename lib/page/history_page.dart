import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    return Scaffold(
      body: Center(
        child: Text('This is the History page.',
            style: TextStyle(color: Colors.blue, fontSize: 20)),
      ),
    );
  }

}