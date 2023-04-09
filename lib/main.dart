import 'package:flutter/material.dart';

import 'Welcomepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel app',
      initialRoute: '/',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/welcomePage':(context)=>const welcomePage(),

      },
      
    );
  }
}


