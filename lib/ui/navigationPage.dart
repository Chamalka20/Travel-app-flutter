import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelapp/ui/search.dart';
import 'package:travelapp/ui/bottomNavigationBar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'Home.dart';
import 'myFavorite.dart';
import 'myTrips.dart';
import 'profile/myAccount.dart';

// ignore: must_be_immutable
class navigationPage extends StatefulWidget {

 final   bool isBackButtonClick; 
 int  autoSelectedIndex;

  navigationPage({required this.isBackButtonClick,required this.autoSelectedIndex, Key? key}) : super(key: key);

  @override
  State<navigationPage> createState() => _navigationPageState(isBackButtonClick,autoSelectedIndex);
}



class _navigationPageState extends State<navigationPage> {

  bool isBackButtonClick;
  int autoSelectedIndex;
  int _selectedIndex = 0;
  late List<Widget> _pages;
   late StreamSubscription<bool> keyboardSubscription;
  bool isKeyboardVisible = false;


   _navigationPageState(this.isBackButtonClick,this.autoSelectedIndex);
  
 
 void _onItemTapped(int index) {
    setState(() {


      _selectedIndex = index;
       isBackButtonClick = true;

      _pages = [
      home(isBackButtonClick: isBackButtonClick),
      const search(isTextFieldClicked: false,searchType:'city',isSelectPlaces: false,),
       mytrips(),
       myFavorite(),
       const myAccount(),
    ] ;

    });

    
  }

   @override
  void initState() {
    super.initState();

    if(autoSelectedIndex==0){
      isBackButtonClick = isBackButtonClick;
      _selectedIndex =_selectedIndex;
      var keyboardVisibilityController = KeyboardVisibilityController();
      _pages = [
        home(isBackButtonClick: isBackButtonClick),
        const search(isTextFieldClicked: false,searchType:'city',isSelectPlaces: false,),
        mytrips(),
        myFavorite(),
        const myAccount(),
      ];
      keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      
      setState(() { isKeyboardVisible = visible; });
      });

    }else{

      _selectedIndex = autoSelectedIndex;

        var keyboardVisibilityController = KeyboardVisibilityController();
      _pages = [
        home(isBackButtonClick: isBackButtonClick),
        const search(isTextFieldClicked: false,searchType:'city',isSelectPlaces: false,),
        mytrips(),
        myFavorite(),
        const myAccount(),
        ];
        keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      
      setState(() { isKeyboardVisible = visible; });
      });
      
    }
     
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: buildBody(),
    );
  }



   Widget buildBody() {
      return GestureDetector(
         onTap: () {
        // Dismiss the keyboard when the user taps outside of the text fields 
        FocusScope.of(context).unfocus();
        
        },
        child: WillPopScope(
          onWillPop: () async {
            
            if(_selectedIndex==0){
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Exit'),
                    content: const Text('Are you sure you want to exit the app?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // User confirmed exit
                          SystemNavigator.pop();
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          // User canceled exit
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
        
              
        
            }else{
              
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  navigationPage(isBackButtonClick: true,autoSelectedIndex: 0,)
                ),
          );  
        
          
              
            }
            
          return false ;
            
          }, 
          child: Scaffold(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              body:_pages[_selectedIndex],


              
              bottomNavigationBar: Visibility(
                visible: !isKeyboardVisible,
                child: navigationBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              ),
            ),
        
            ), 
        
          );
      

    
  }
}