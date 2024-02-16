
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:travelapp/blocs/user/user_bloc.dart';
import 'package:travelapp/ui/emailVerificationPage.dart';
import 'blocs/place/placeList_bloc.dart';
import 'ui/Welcomepage.dart';
import 'ui/navigationPage.dart';

Future<void> checkLoggedIn() async {
 
  FirebaseAuth.instance.currentUser?.reload();
  FirebaseAuth.instance.authStateChanges().listen((user) { 
    print(user);
    if(user != null) {
      if(user.emailVerified != false){
        runApp(const MyApp(initialRoute: '/home'));
      }else{
        runApp(const MyApp(initialRoute: '/emailVerification'));
      }
      
    }else{
      runApp(const MyApp(initialRoute: '/login'));
    } 
    
  });
   
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load();
  checkLoggedIn();
  
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => placeListBloc()),
        BlocProvider(create: (context) => userBloc()),

      ],child:MaterialApp(
     debugShowCheckedModeBanner: false,
     initialRoute:initialRoute,
     routes: {
        '/login': (context) => const welcomePage(),
        '/home': (context) =>  navigationPage(isBackButtonClick:false,autoSelectedIndex: 0,),
        '/emailVerification': (context) => const emailVerificationPage(),
      },
      
    ),

    );
    
     
  }
}
