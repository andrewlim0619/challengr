import 'package:challengr/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.mainOrange,
          foregroundColor: textColor ?? Colors.white,  // text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
