import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'SplashScreen.dart';
import 'AppRoutes.dart';
import 'Home.dart';
import 'Welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
      routerDelegate: myAppRoter().router.routerDelegate,
      routeInformationParser: myAppRoter().router.routeInformationParser,
      
    );
  }
}
