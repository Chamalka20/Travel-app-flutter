
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/Welcomepage.dart';
import 'ui/navigationPage.dart';

Future<bool> checkLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load();
  
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
     debugShowCheckedModeBanner: false,
     initialRoute:initialRoute,
     routes: {
        '/login': (context) => const welcomePage(),
        '/home': (context) =>  navigationPage(isBackButtonClick:false,autoSelectedIndex: 0,),
      },
      
    );
  }
}
