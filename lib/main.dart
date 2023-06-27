
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';

import 'Welcomepage.dart';
import 'navigationPage.dart';

Future<bool> checkLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  
  bool isLoggedIn = await checkLoggedIn();
  String initialRoute = isLoggedIn ? '/home' : '/login';

  runApp(MyApp(initialRoute: initialRoute));

  
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

     initialRoute:initialRoute,
     routes: {
        '/login': (context) => const welcomePage(),
        '/home': (context) =>  const navigationPage(isBackButtonClick:false),
      },
      
    );
  }
}
