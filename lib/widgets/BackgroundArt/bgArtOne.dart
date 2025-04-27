import 'package:flutter/material.dart';

class BGArtOne extends StatelessWidget {
  const BGArtOne({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        //Right character image
        Positioned(
          bottom: screenHeight * 0,
          right: screenWidth * 0,
          child: Image.asset(
            'assets/characters/orangeCharacter2.png',
            width: screenWidth * 0.63,
            fit: BoxFit.cover,
          ),
        ),

        //Middle character image
        Positioned(
          bottom: screenHeight * 0,
          left: -screenWidth * 0.0,
          child: Image.asset(
            'assets/characters/pinkCharacter1.png',
            width: screenWidth * 1,
            fit: BoxFit.cover,
          ),
        ),

        //Left character image
        Positioned(
          bottom: screenHeight * 0,
          left: screenWidth * 0,
          child: Image.asset(
            'assets/characters/orangeCharacter1.png',
            width: screenWidth * 0.6,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
