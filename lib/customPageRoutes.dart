import 'package:flutter/material.dart';

class customPageRoutes extends PageRouteBuilder {
  final Widget child;

  customPageRoutes({
    required this.child, 
   
    }) : super (
      transitionDuration: Duration(milliseconds: 450),
      reverseTransitionDuration:  Duration(seconds: 1),
      pageBuilder: (context,animation,secondaryAnimation)=>child
      );

  @override
  Widget buildTransitions(BuildContext context,Animation<double> animation,
  Animation<double> secondaryAnimation, Widget child) =>
    
    SlideTransition(
      position:Tween<Offset>(
        begin:Offset(-1,0),
        end:Offset.zero
      ).animate(animation),
      child: child,
      
      );





}