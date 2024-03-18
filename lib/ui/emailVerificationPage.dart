import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:travelapp/ui/Welcomepage.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_event.dart';
import 'customPageRoutes.dart';
import 'letsStart.dart';

class emailVerificationPage extends StatefulWidget {
  const emailVerificationPage({super.key});

  @override
  State<emailVerificationPage> createState() => _emailVerificationPageState();
}

class _emailVerificationPageState extends State<emailVerificationPage> {

  Timer? timer;
  bool isEmailVerified = false;
  User? user;

  @override
  void initState() {
    super.initState();
  
     BlocProvider.of<userBloc>(context).add(emailVerification());
     timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());

  }

  checkEmailVerified() async {
    
    user=await userBlo.getUserDetails();
    setState(() {
      isEmailVerified=user!.emailVerified; 
    });
    
    if (isEmailVerified) {
      
      timer?.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(           
            builder:(context)=> const letsStart()));
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child:SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              height: 700.0, 
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/app bac.jpg'),
                    fit:BoxFit.cover,
                    alignment: Alignment.center,

                  ),

                ),
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  iconSize: 40,
                                  onPressed: () {

                                    Navigator.of(context).pushReplacement(customPageRoutes(
                                    child:const welcomePage()));

                                    // Handle back button press
                                  },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 50.0,top:100.0, ),
                              child: Text("Email Verification",
                                style: GoogleFonts.lato(
                                  // ignore: prefer_const_constructors
                                  textStyle: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,

                                 ) 
                                )
                              ),
                            )
                          ],

                        ),
                        
                        Row(
                          children: [
                            Container(
                               margin: const EdgeInsets.only(left: 35.0,),
                                height: 300,
                                width: 300,
                              child: Container(
                                  // ignore: prefer_const_constructors
                                  
                                  margin: const EdgeInsets.only(left: 0.0),
                                  decoration: const BoxDecoration(
                                    
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/Rectangle 1 loging.png'),
                                     
                                        ),
                                    
                                    ), 
                                alignment: Alignment.center,
                                child: Column(
                                    children: [
                                        
                                        Row(
                                          children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top:60.0,left: 60),
                                                child: Container(
                                                  child: Text("We have sent you a Email \non ${user?.email}",
                                                      style: GoogleFonts.roboto(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        
                                                      ),
                                                      maxLines: 2,
                                                      textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ) ,
                                          ],
                                
                                        ),
                                        Row(
                                          children:[
                                            Padding(
                                              padding: const EdgeInsets.only(left:125,top:20),
                                              child: Center(
                                                child: LoadingAnimationWidget.hexagonDots(
                                                    color: Color.fromARGB(255, 255, 255, 255), 
                                                    size: 35,
                                                  ),
                                              ),
                                            ),
                                          ]
                                        ),
                                        
                                        Row(
                                          children: [
                                             Padding(
                                               padding: const EdgeInsets.only(left:25,top:24),
                                               child: Container(
                                                  width: 250,
                                                  height: 40, 
                                                 child: TextButton(
                                                    onPressed: ()  async {
                                                       
                                                      BlocProvider.of<userBloc>(context).add(emailVerification());
                                   
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 10, 124, 132)),
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                    ),
                                                    child: Text('Resend',
                                                        style: GoogleFonts.roboto(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15,
                                               
                                                        ),
                                                    
                                                    ),
                                                  ),
                                               ),
                                             ),
                                
                                
                                          ],
                                        ),
                                        
                                    ], 
                                
                                
                                ),  

                              ),

                            )
                              
                          ],

                        )
                      ],
                    ),
                  ),

                ),
            ),

          
        ),  
      )
    );
  }
}