import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelapp/SplashScreen.dart';
import 'package:travelapp/Welcomepage.dart';
import 'Home.dart';
import 'Welcomepage.dart';



class myAppRoter {

  GoRouter router = GoRouter(
    
    routes:[
      GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              
              return const MaterialPage(child: SplashScreen());
            },
          ),
      GoRoute(
            path: '/welcome',
            pageBuilder: (context, state) {
             
              return const MaterialPage(child: welcomePage());
            },
          ),
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) {
              
              return const MaterialPage(child: home());
            },
          ),


    ]
    
    
    
    ); 


}