import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'Google_signin.dart';
import 'Home.dart';
import 'Welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
        navigate();
    });

  }
  void navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final user = await GoogleSigninApi.login();
      // ignore: use_build_context_synchronously
      if (user == null){

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content:Text("Login Faild"))); 


      }else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          
          builder:(context)=> home()));
      
      

      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const welcomePage()),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        
        child: Container(
          decoration: const BoxDecoration(
            color:Color.fromARGB(255, 0, 0, 0), 

            

          ),
          child: Center(
            child: Text("Sri travel",
                      style: GoogleFonts.pacifico(
                      // ignore: prefer_const_constructors
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 50,
                        
                      ),
                    
                
                    ),
                  ),
          ),
          
        ),
      ),
    );
  }
}
