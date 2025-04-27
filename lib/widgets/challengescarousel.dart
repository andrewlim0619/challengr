import 'package:flutter/material.dart';
import 'package:challengr/theme.dart';
import 'package:challengr/font.dart';
import 'package:challengr/widgets/BackgroundArt/bgArtTwo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

    return Scaffold(
      backgroundColor: AppColors.mainBiege,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BGArtTwo(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: userDocRef.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Text(
                              'Welcome back!',
                              style: AppFonts.heading2,
                            );
                          }
                          final data = snapshot.data!.data() as Map<String, dynamic>;
                          final username = data['username'] as String? ?? user.email ?? '';
                          return Text.rich(
                            TextSpan(
                              text: 'Welcome back,\n',
                              style: AppFonts.heading2,
                              children: [
                                TextSpan(
                                  text: '$username!',
                                  style: AppFonts.heading2.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: _logout,
                        tooltip: 'Log Out',
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Challenge Your Friend!',
                          style: AppFonts.heading2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/characters/mainOrangeCharacter.png',
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            Text(
                              'VS',
                              style: AppFonts.heading2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            Image.asset(
                              'assets/characters/mainPinkCharacter.png',
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                            ),
                          ],
                        ),
                      ],
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
