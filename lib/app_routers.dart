import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'Home.dart';
import 'SplashScreen.dart';
import 'Welcomepage.dart';

class myAppRouters{

  GoRouter router = GoRouter(
    
    
    routes:[
         GoRoute(
                  path: '/',
                  pageBuilder: (context, state) {
                  
                    return const MaterialPage(child:SplashScreen());
                  },
                ),
                
        GoRoute(
                  path: '/home',
                  pageBuilder: (context, state) {
                  
                    return const MaterialPage(child:home());
                  },
                ),
         GoRoute(
                  path: '/welcome',
                  pageBuilder: (context, state) {
                  
                    return const MaterialPage(child:welcomePage());
                  },
                ),



    ]
    
    
    
    ); 


}