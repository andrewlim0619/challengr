import 'package:flutter/material.dart';
import 'package:challengr/theme.dart';
import 'package:challengr/widgets/BackgroundArt/bgArtTwo.dart';
import 'package:challengr/font.dart';

class AcceptChallengePage extends StatelessWidget {
  const AcceptChallengePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mainBiege,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BGArtTwo(),

          // foreground content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Challenge Accepted!',
                    style: AppFonts.heading2.copyWith(
                      fontSize: 28,
                      color: AppColors.mainOrange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'You can now track your challenge progress in the Challenges tab.',
                    style: AppFonts.parText,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainPink,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: Text(
                      'Back to Home',
                      style: AppFonts.parText.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
