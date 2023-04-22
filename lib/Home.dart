import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Google_signin.dart';
import 'Welcomepage.dart';

class home extends StatefulWidget {

  final GoogleSignInAccount user;
  const home({
     Key? key,
     required this.user, 
  
  }):super(key: key);

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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.user.photoUrl!),
                ),
                 TextButton(
                  // ignore: void_checks
                  onPressed: () async{

                   await GoogleSigninApi.logout();
                   
                    // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder:(context)=>const welcomePage()));

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);

                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 10, 124, 132)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text('Logout',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,

                      ),
                  
                  ),
                ),
              ],
            )
          ],

        ),

       ),
       
      ),
    );
  }
}