import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travelapp/bottomNavigationBar.dart';

import 'Home.dart';
import 'customPageRoutes.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(customPageRoutes(
            
        child:const home(isBackButtonClick: true,)));  

        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child:Column(
            children: [
              Row(
                children: [
                  Text("this is a search")
                  
                ]  
              ),Row(

                children: [
                   
                ],
                  
              )
            ],
          )
           
          ),
          
    
      ),
    );
  }
}