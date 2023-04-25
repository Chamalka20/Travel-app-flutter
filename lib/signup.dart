import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'Welcomepage.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            
        builder:(context)=> const welcomePage()));  

        return false;
      },
      child: Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
           physics: const NeverScrollableScrollPhysics(),
           child: Container(
            height: 700,
             decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/app bac.jpg'),
                    fit:BoxFit.cover,
                    alignment: Alignment.center,

                  ),

                ),

           ),

          )
        ),

      
      )
    );
  }
}