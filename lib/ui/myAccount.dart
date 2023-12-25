import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/ui/fechApiData.dart';

import 'Google_signin.dart';
import 'Welcomepage.dart';

class myAccount extends StatefulWidget {
  const myAccount({super.key});

  @override
  State<myAccount> createState() => _myAccountState();
}

class _myAccountState extends State<myAccount> {

  var  data ={};
  var isDataReady;


  void initState() {
    super.initState();
   getUserData(); 
     
  }

  Future <void> getUserData()async{
    data = await fechApiData.getUserData();

    if(data == null){

        setState(() {
          data ;
          isDataReady= false;
          
        });
        
        
      }else{
         setState(() {
           data ;
          isDataReady= true;
         
        });
      }

    
  }


  Future <void> logOut()async{

    final prefs = await SharedPreferences.getInstance();
    bool? isLocalAccount = prefs.getBool('isLocalAccount');
    
  if(isLocalAccount ==true){

    await prefs.setBool('isLoggedIn', false);

    // ignore: use_build_context_synchronously
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  welcomePage()),
    );



  }else{
     await GoogleSigninApi.logout();

     await prefs.setBool('isLoggedIn', false);

    // ignore: use_build_context_synchronously
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  welcomePage()),
    );

  }

  
    

  }

  @override
  Widget build(BuildContext context) {
    if(isDataReady == true){

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
              GestureDetector(
                onTap: () {
                  
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
                        backgroundImage:data['proPicUrl']!=null? NetworkImage(data['proPicUrl']):NetworkImage("https://via.placeholder.com/150"),
                        
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
                                child: Text("${data['name']}",
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
                                    child: Text("${data['email']}",
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
                    onPressed: () async {
                      
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

  }else{
    return const Center(
        child: CircularProgressIndicator(),
      );

  }
  }
}