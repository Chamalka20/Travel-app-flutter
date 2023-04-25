import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'SplashScreen.dart';
import 'app_routers.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
     routeInformationParser: myAppRouters().router.routeInformationParser,
     routerDelegate: myAppRouters().router.routerDelegate,
      
    );
  }
}
