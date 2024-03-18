import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/blocs/user/user_event.dart';

import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_state.dart';
import 'Welcomepage.dart';
import 'customPageRoutes.dart';
import 'emailVerificationPage.dart';


class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  final emailController = TextEditingController();
  final nameController =TextEditingController();
  final passwordController =TextEditingController();

  bool isEmailEmpty =false;
  bool isNameEmpty =false;
  bool isPasswordEmpty =false;
  bool showError = false;
  String errorDetails='';

  bool isSameEmail =false;
  List curruntEmails=[];
  var userId ;

@override
  void dispose(){
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();

  }

 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when the user taps outside of the text fields 
        FocusScope.of(context).unfocus();
        
      },
    
    
    child: WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(customPageRoutes(
            
        child:const welcomePage())); 

        return false;
      },

      child:MultiBlocListener(
        listeners:[

          BlocListener<userBloc, userState>(
            listener: (context, state) async {

              if(state is singUpState){

                if(state.SignUpData=='successful'){

                  showError = false;

                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                      
                      builder:(context)=> const emailVerificationPage()));

                }else{

                  setState(() {
                    showError = true;
                    errorDetails=state.SignUpData;
                  });
                  
                  
                }

              }
          
           },
         ),

        ],
        child: Scaffold(
          body: SafeArea(
            child:Container(
            height: 700,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/app bac.jpg'),
                    fit:BoxFit.cover,
                    alignment: Alignment.center,

                  ),

                ),
            child: LimitedBox(
                maxHeight:700,
                child: SingleChildScrollView(
                  
                  child:Center(
                      child: Column(
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
                        //show error-----------------------------------
                        Visibility(
                          visible: showError,
                          child: Row(
                            children: [
                                Container(
                                width:250,
                                height:30,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(17)
                                  ),
                                margin: const EdgeInsets.only(left: 50.0,bottom:1 ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(errorDetails,
                                        style: GoogleFonts.lato(
                                            // ignore: prefer_const_constructors
                                            textStyle: TextStyle(
                                            color: Color.fromARGB(255, 255, 0, 0),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                
                                            ) 
                                          )
                                      
                                      ),
                                    ],
                                  ),
                                )  
                        
                            ],
                        
                          ),
                        ),
                        Row(
                          children: [
                              Container(
                              margin:showError? const EdgeInsets.only(left: 50.0,top:50.0,bottom:20.0 ):const EdgeInsets.only(left: 50.0,top:80.0,bottom:20.0 ),
                                child: Text("Sign up",
                                  style: GoogleFonts.lato(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 35,
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
                                  margin: const EdgeInsets.only(left: 40.0,),
                                  height: 390,
                                  width: 290,
                                child: Container(
                                    // ignore: prefer_const_constructors
                                    
                                    margin: const EdgeInsets.only(left: 0.0),
                                    decoration: const BoxDecoration(
                                      
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/Rectangle 1.png'),
                                        
                                  
                                          ),
                                      
                                      ), 

                                  child: Container(

                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 25.0,left:20.0),
                                                child: Text("Let's create a new account",
                                                  style: GoogleFonts.roboto(
                                                      color: const Color.fromARGB(255, 255, 255, 255)
                                                  ),
                                                
                                                ),
                                              )

                                            ],

                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:20.0,top:15),
                                                child: Container(
                                                  width: 250,
                                                  height: isEmailEmpty? 60:40,
                                                  child: TextField(
                                                          onTap: () {
                                                            setState(() {
                                                              showError = false;
                                                            });
                                                          },
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: Color.fromARGB(255, 255, 255, 255),
                                                            hintText: 'Email',
                                                            errorText:isEmailEmpty  ? "Value Can't Be Empty" : null,
                                                            border: const OutlineInputBorder(
                                                              borderSide: BorderSide.none,
                                                            
                                                            ),
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                          ),
                                                          controller: emailController,
                                                          
                                                        ),
                                                ),
                                              ),

                                            ],


                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:20.0,top:15),
                                                child: Container(
                                                  width: 250,
                                                  height: isNameEmpty? 60:40,
                                                  child:  TextField(
                                                          controller: nameController,
                                                          decoration:  InputDecoration(
                                                            filled: true,
                                                            fillColor: Color.fromARGB(255, 255, 255, 255),
                                                            hintText: 'Name',
                                                            errorText:isNameEmpty  ? "Value Can't Be Empty" : null,
                                                            border:const OutlineInputBorder(
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
                                                padding: const EdgeInsets.only(left:20.0,top:15),
                                                child: Container(
                                                  width: 250,
                                                  height: isPasswordEmpty? 60:40,
                                                  child: TextField(
                                                          controller: passwordController,
                                                          obscureText: true,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: Color.fromARGB(255, 255, 255, 255),
                                                            hintText: 'Password',
                                                            errorText:isPasswordEmpty  ? "Value Can't Be Empty" : null,
                                                            border:const OutlineInputBorder(
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
                                                padding: const EdgeInsets.only(left:20.0,top:15),
                                                child: Text("By secting Agree and continue below,",
                                                      style: GoogleFonts.roboto(
                                                        color: const Color.fromARGB(255, 255, 255, 255),
                                                        fontSize: 12.5,
                                                    ),
                                                                    
                                              
                                                  ),
                                              ),
                                          
                                            ],

                                            

                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:20.0),
                                                child: Text("I agree to",
                                                      style: GoogleFonts.roboto(
                                                        color: const Color.fromARGB(255, 255, 255, 255),
                                                        fontSize: 12.5,
                                                    ),
                                                                    
                                              
                                                  ),
                                              ),
                                              Container(
                                                //margin: EdgeInsets.only(right: 80.0,),
                                                child: Text(" Terms of service and privacy policy",
                                                      style: GoogleFonts.roboto(
                                                        color: const Color.fromARGB(255, 27, 199, 211),
                                                        fontSize: 12.5,
                                                      ),
                                                      
                                                
                                                ),
                                              ) 
                                              
                                            ],


                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.only(left: 15.0,top: 15.0),
                                                  child: SizedBox(
                                                      width: 250,
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        onPressed: ()async {

                                                          setState(() {
                                                            emailController.text.isEmpty ? isEmailEmpty = true : isEmailEmpty = false;
                                                            nameController.text.isEmpty ? isNameEmpty = true : isNameEmpty = false;
                                                            passwordController.text.isEmpty ? isPasswordEmpty = true : isPasswordEmpty = false;


                                                          });

                          
                                                          if(emailController.text.isNotEmpty&&nameController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                                                            
                                                          
                                                           BlocProvider.of<userBloc>(context).add(signUpEvent( email:emailController.text, name:nameController.text, password: passwordController.text, proPicUrl: ''));
                                                            
                                                          } 
                                                        
                                                          
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 10, 124, 132)),
                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                        ),
                                                        child: Text('Continue',
                                                            style: GoogleFonts.roboto(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 15,

                                                            ),
                                                        
                                                        ),
                                                      ),
                                                    ),
                                                ),

                                            ],


                                          )

                                        ],

                                      ),

                                  ),
                                )
                              )

                            ],


                        )
                      ],

                      ), 
                  )               
                )


            ),
            )
            ),

          
          ),
      )
       
      )
    );
  }
}