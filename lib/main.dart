import 'package:challengr/screen/login.dart';
import 'package:challengr/screen/signup.dart';
import 'package:challengr/screen/splashscreen.dart';
import 'package:challengr/screen/home.dart';
import 'package:challengr/screen/confirmChallenge.dart';
import 'package:challengr/screen/startChallenge.dart';
import 'package:challengr/screen/viewChallenges.dart';
import 'package:challengr/screen/viewRequests.dart';
import 'package:flutter/material.dart';

// Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async { 
  //Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Challengr',
    
      routes: {
        '/': (context) => const SplashScreen(),
        '/LoginPage': (context) => const LoginPage(),
        '/SignUpPage': (context) => const SignUpPage(),
        '/HomePage': (context) => const HomePage(),
        '/ViewChallenges': (context) => const ViewChallenges(),
        '/StartChallenge': (context) => const StartChallenge(),
        '/ViewRequests': (context) => const ViewRequests(),
      },
    );
  }
}