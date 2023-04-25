import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Google_signin.dart';
import 'Welcomepage.dart';

class home extends StatefulWidget {

   const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
       child: Container(
        child: Column(
          children: [
            Row(
              children: [
                
              ],
            )
          ],

        ),

       ),
       
      ),
    );
  }
}