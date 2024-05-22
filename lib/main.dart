
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:travelapp/blocs/user/user_bloc.dart';
import 'package:travelapp/ui/emailVerificationPage.dart';
import 'blocs/place/placeList_bloc.dart';
import 'blocs/trip/trip_bloc.dart';
import 'network_controller.dart';
import 'ui/Welcomepage.dart';
import 'ui/navigationPage.dart';

Future<void> checkLoggedIn() async {
  
  FirebaseAuth.instance.currentUser?.reload();
  FirebaseAuth.instance.authStateChanges().listen((user) { 
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
  await dotenv.load(fileName: '.env');
  Get.put<NetworkController>(NetworkController(),permanent:true);
  checkLoggedIn();
  
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<placeListBloc>(create: (BuildContext context) => placeListBloc()),
        BlocProvider<userBloc>(create: ( context) => userBloc()),
        BlocProvider(create: (context) => tripBloc(),)

      ],child:GetMaterialApp(
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
