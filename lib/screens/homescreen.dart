import 'package:flutter/material.dart';
import 'package:flutter_driver_uber_app/widgets/main_drawer.dart';
import '../widgets/maps.dart';

class HomeScreen extends StatelessWidget{
  static const routeArgs = 'homescreen';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Maps(scaffoldKey),
      drawer: MainDrawer(),
    );
  }
}
