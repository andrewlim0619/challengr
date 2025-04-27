import 'package:flutter/material.dart';

class BGArtTwo extends StatelessWidget {
  const BGArtTwo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        //Top Shape
        Positioned(
          bottom: screenHeight * 0,
          left: screenWidth * 0,
          child: Image.asset(
            'assets/orangeShape.png',
            width: screenWidth * 0.9,
            fit: BoxFit.cover,
          ),
        ),

        //Bottom Shape
        Positioned(
          top: screenHeight * 0,
          right: screenWidth * 0.0,
          child: Image.asset(
            'assets/pinkShape.png',
            width: screenWidth * 0.9,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
