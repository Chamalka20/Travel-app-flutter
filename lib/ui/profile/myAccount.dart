import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../Welcomepage.dart';
import 'editProfile.dart';


class myAccount extends StatefulWidget {
  const myAccount({super.key});

  @override
  State<myAccount> createState() => _myAccountState();
}

class _myAccountState extends State<myAccount> {

  late auth.User user;

  void initState() {
    super.initState();
     
  }

  Future <void> logOut()async{

    BlocProvider.of<userBloc>(context).add(signOutEvent());
    
    userBlo.authState.listen((user) {

      if(user == null){

         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  welcomePage()),
        );

      }
      
    });

   

  }


@override 
  Widget build(BuildContext context) {
        return Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:40,left:13),
                    child: Row(
                      children: [
                        Text("Account",
                          style: GoogleFonts.nunito(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: const Color.fromARGB(255, 27, 27, 27),
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                              
                                      ) 
                                    )
                        
                        ),
                      ],
                    ),
                  ),
                  //account details---------------------------------------------------------
                  FutureBuilder(
                    future: userBlo.getUserDetails(),
                    builder: (context,AsyncSnapshot<auth.User?> snapshot) {
                      
                      if(snapshot.hasData){
                        user=snapshot.data!;
                        return
                         GestureDetector(
                            onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfile(user: user,)));
                            },
                            child: Row(
                              children: [
                              Padding(
                                padding: const EdgeInsets.only(left:13,top:10),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  child:  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:snapshot.data?.photoURL!=null? NetworkImage("${snapshot.data?.photoURL}")
                                    :const NetworkImage("https://cdn-icons-png.flaticon.com/64/3177/3177440.png"),
                                    
                                  ),
                                ),
                              ),
                              
                                Column(
                                  children: [
                            
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top:20),
                                          child: SizedBox(
                                          width:290,
                                            child: Text("${snapshot.data?.displayName}",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                    fontSize: 18,
                                                                        
                                                    ), 
                                                                                            
                                                                                            
                                              ),
                                                                                    
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:6),
                                              child: SizedBox(
                                                width:290,
                                                child: Text("${snapshot.data?.email}",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                      fontSize: 12,
                                                                          
                                                      ), 
                                                                                                
                                                                                                
                                                ),
                                                                                      
                                                ),
                                              ),
                                            ),
                            
                            
                                      ],
                            
                            
                            
                                    )
                                  ],
                                ),  
                              ],
                            
                            ),
                          );
            
                      }else{
            
                        return Container();
            
                      }
                      
                    }
                  ),
                  //preferences------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.only(left:13,top:34),
                    child: Row(
                      children: [
                        Text("Preferences",
                          style: GoogleFonts.nunito(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: const Color.fromARGB(255, 27, 27, 27),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                              
                                      ) 
                                    )
                        
                        ),
                      ],
                    ),
                  ),
            
                  Padding(
                    padding: const EdgeInsets.only(top:300),
                    child: SizedBox(
                      width: 200,
                      height: 45,
                      child: TextButton(
                        onPressed: () {
                          
                         logOut();
            
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          foregroundColor:Color.fromARGB(255, 0, 0, 0),
                          side: BorderSide(
                            width: 2.0,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), 
                            ),
                          
                        ),
                        child: Text('Log out',
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
            );

              
          }
       



}
