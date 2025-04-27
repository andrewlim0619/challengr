import 'package:flutter/material.dart';

class AuthPageLogo extends StatelessWidget {
  final String imagePath;
  final double imageWidth;

  const AuthPageLogo({
    super.key,
    required this.imagePath,
    this.imageWidth = 125, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Image.asset(
          imagePath,
          width: imageWidth,
        ),
      ],
    );
  }
}
