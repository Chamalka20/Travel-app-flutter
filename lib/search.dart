import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travelapp/bottomNavigationBar.dart';

import 'Home.dart';
import 'customPageRoutes.dart';

class search extends StatefulWidget {
  const search({super.key,});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {

  
  

  @override
  Widget build(BuildContext context) {
    return 
       SafeArea(
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
         
        );
        
    
  
  }
}