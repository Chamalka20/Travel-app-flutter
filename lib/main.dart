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
