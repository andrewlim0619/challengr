import 'package:challengr/theme.dart';
import 'package:challengr/widgets/BackgroundArt/bgArtOne.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  // Check if user is signed in and navigate accordingly
  void _checkUserAuthentication() async {
    await Future.delayed(const Duration(seconds: 4));
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        user == null ? '/LoginPage' : '/HomePage',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background art
          const BGArtOne(),

          // Foreground content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/characters/challengrLogo.png',
                  width: screenWidth * 0.4,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: AppColors.mainPink,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.mainBiege,
    );
  }
}
