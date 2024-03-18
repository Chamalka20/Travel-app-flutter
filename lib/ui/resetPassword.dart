
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/ui/customPageRoutes.dart';

import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_event.dart';
import '../blocs/user/user_state.dart';
import 'Welcomepage.dart';

class resetPasswordPage extends StatefulWidget {
  const resetPasswordPage({super.key});

  @override
  State<resetPasswordPage> createState() => _resetPasswordPageState();

 
}

class _resetPasswordPageState extends State<resetPasswordPage> {

  final emailController = TextEditingController();
  bool showError =false;
  String errorDetails = '';
  late userBloc userbloc;
  late StreamSubscription mSub;

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    

  }

  @override
  Widget build(BuildContext context) {

    userbloc = BlocProvider.of<userBloc>(context);

       mSub = userbloc.stream.listen((state) {
          if(state is resetPasswordState){

            if(state.resetState[0]['isSend'] == true){
                    
                    Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:(context)=> welcomePage()
                            
                          )
                        );
                          
                 mSub.cancel(); 
                }else{
                  setState(() {
                    showError=true;
                    errorDetails=state.resetState[0]['AuthException'];
                  });
                  
                }
          }
       
       });
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(customPageRoutes(
            
        child:const welcomePage())); 

        return false;
      },

      child: Scaffold(
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
                                child: Text("Reset Password",
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
                                                    child: Text("Please enter your email address \nto recover your password",
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
                                            children: [
                                               Padding(
                                                 padding: const EdgeInsets.only(left:25,top:24),
                                                 child: Container(
                                                  width: 250,
                                                  height: showError? 60:40,
                                                   child: TextField(
                                                    onTap: () {
                                                      setState(() {
                                                            showError = false;
                                                          });
                                                    },
                                                      controller: emailController,
                                                      decoration:  InputDecoration(
                                                        filled: true,
                                                        fillColor: Color.fromARGB(255, 255, 255, 255),
                                                        hintText: 'email',
                                                        errorText:showError  ? errorDetails : null,
                                                        border: const OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                        
                                                        ),
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                      ),
                                                    ),
                                                 ),
                                               ),
      
      
                                            ],
      
      
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
      
                                                        if(emailController.text.isNotEmpty){
                                                          BlocProvider.of<userBloc>(context).add(resetPassword(email:emailController.text));
                                                        }else{
                                                          setState(() {
                                                            showError =true;
                                                            errorDetails="email is empty";
                                                          });
                                                          
                                                        }
                                                         
                                                        
                                     
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 10, 124, 132)),
                                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                      ),
                                                      child: Text('Send',
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
      ),
    );
  }
}