import 'package:flutter/material.dart';

class GraphicalPage extends StatelessWidget {
  const GraphicalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is the Graphical page.', style: TextStyle(color: Colors.teal, fontSize: 20)),
      ),
    );
  }
}