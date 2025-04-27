import 'package:challengr/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  //Login and Sign Up Screen Fonts
  static TextStyle welcomeText = GoogleFonts.lalezar(
    fontSize: 42,
    fontWeight: FontWeight.normal,
    color: AppColors.mainOrange, 
  );

  //Fonts for anything text field related
  static TextStyle textFieldProperties = GoogleFonts.karla(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.mainBlack, 
  );

  /*
   * MAIN NAVIGATION FONTS GOES HERE
   */
  static TextStyle heading1 = GoogleFonts.karla(
    fontSize: 40,
    fontWeight: FontWeight.normal,
    color: AppColors.mainBlack, 
  );

  static TextStyle otherHeading2 = GoogleFonts.lalezar(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.mainBlack, 
  );

  static TextStyle heading2 = GoogleFonts.karla(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.mainBlack, 
  );

  static TextStyle parText = GoogleFonts.karla(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.mainBlack, 
  );

  static TextStyle signUpOnBoardHeadings = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.grey1, 
  );
  
  static TextStyle buttonText = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.mainBiege, 
  );

  static TextStyle authButtonText = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.mainBlack, 
  );

  static TextStyle userProfileText = GoogleFonts.spaceGrotesk(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryGrey, 
  );
}
