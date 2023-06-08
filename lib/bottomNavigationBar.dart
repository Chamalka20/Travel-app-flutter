
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/search.dart';

import 'Home.dart';
import 'customPageRoutes.dart';

// ignore: camel_case_types
class navigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const navigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 800,
      color: Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavigationBarItem(
            icon: 'assets/images/homeClick.png',
            title: 'Home',
            index: 0,
            selectedIndex: selectedIndex,
            onTap: onItemTapped,
          ),
          NavigationBarItem(
            icon: 'assets/images/search.png',
            title: 'Search',
            index: 1,
            selectedIndex: selectedIndex,
            onTap: onItemTapped,
          ),
          NavigationBarItem(
            icon: 'assets/images/map.png',
            title: 'Plan',
            index: 2,
            selectedIndex: selectedIndex,
            onTap: onItemTapped,
          ),
          NavigationBarItem(
            icon: 'assets/images/like.png',
            title: 'Favorite',
            index: 3,
            selectedIndex: selectedIndex,
            onTap: onItemTapped,
          ),
          NavigationBarItem(
            icon: 'assets/images/user.png',
            title: 'Account',
            index: 4,
            selectedIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ],
      ),
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  final String icon;
  final String title;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavigationBarItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(icon, width: 20, height: 20),
          SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.cabin(
              textStyle: TextStyle(
                color: index == selectedIndex
                    ? Color.fromARGB(255, 0, 0, 0)
                    : Color.fromARGB(255, 189, 188, 188),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
 



