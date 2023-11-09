import 'package:flutter/material.dart';

class Circlebutton extends StatelessWidget {
   final IconData icon;
  final double iconSize;
  final Function onPressed;

   Circlebutton({super.key,
   required this.icon,
   required this.iconSize,
    required this.onPressed});



  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onPressed(),
               icon:Icon(icon),
              iconSize: iconSize,
              ));
  }
}