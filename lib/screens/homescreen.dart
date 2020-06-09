import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeArgs = '/homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
