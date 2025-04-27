import 'package:flutter/material.dart';
import 'package:challengr/widgets/custombutton.dart';
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
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (route) => false);
  }

  void _showAddFriendDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Friend'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Friend Username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              final query = await _firestore
                  .collection('users')
                  .where('username', isEqualTo: name)
                  .limit(1)
                  .get();
              if (query.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not found')),
                );
              } else {
                final friendId = query.docs.first.id;
                await _firestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'friendList': FieldValue.arrayUnion([friendId]),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Friend added')),
                );
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final user = _auth.currentUser!;
    final userRef = _firestore.collection('users').doc(user.uid);

    return Scaffold(
      backgroundColor: AppColors.mainBiege,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BGArtTwo(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: userRef.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            final data = snapshot.data!.data() as Map<String, dynamic>;
                            final username = data['username'] as String? ?? '';
                            return Text.rich(
                              TextSpan(
                                text: 'Welcome back,\n',
                                style: AppFonts.heading2,
                                children: [
                                  TextSpan(
                                    text: '$username!',
                                    style: AppFonts.heading2.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          color: AppColors.mainBlack,
                          onPressed: _logout,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'CHALLENGE',
                            style: AppFonts.otherHeading2.copyWith(
                              fontSize: 30,
                              color: AppColors.mainOrange.withOpacity(0.5),
                            ),
                          ),
                          TextSpan(
                            text: ' & GROW\nWith Friends',
                            style: AppFonts.otherHeading2.copyWith(fontSize: 30),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/characters/mainPinkCharacter.png',
                          width: screenWidth * 0.2,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'VS',
                          style: AppFonts.heading2.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Image.asset(
                          'assets/characters/mainOrangeCharacter.png',
                          width: screenWidth * 0.18,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomButton(
                      text: 'View Current Challenges',
                      onPressed: () => Navigator.of(context).pushNamed('/ViewChallenges'),
                      width: double.infinity,
                      backgroundColor: AppColors.mainPink,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'New Challenge',
                            onPressed: () => Navigator.of(context).pushNamed('/StartChallenge'),
                            width: double.infinity,
                            backgroundColor: AppColors.mainOrange,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: CustomButton(
                            text: 'Requests',
                            onPressed: () => Navigator.of(context).pushNamed('/ViewRequests'),
                            width: double.infinity,
                            backgroundColor: AppColors.mainOrange,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Text('FRIENDS', style: AppFonts.otherHeading2, textAlign: TextAlign.center),
                    StreamBuilder<DocumentSnapshot>(
                      stream: userRef.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final friends = List<String>.from(data['friendList'] ?? []);
                        if (friends.isEmpty) {
                          return const Center(child: Text('No friends yet'));
                        }
                        return Column(
                          children: friends.map((fUid) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: _firestore.collection('users').doc(fUid).get(),
                              builder: (context, fSnap) {
                                if (!fSnap.hasData) {
                                  return ListTile(title: Text('Loading...'));
                                }
                                final fData = fSnap.data!.data() as Map<String, dynamic>;
                                final name = fData['username'] as String? ?? '';
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.secondaryGrey,
                                    child: Text(
                                      name.isNotEmpty ? name[0] : '',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(name, style: AppFonts.parText),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomButton(
                      text: 'Add New Friend',
                      onPressed: _showAddFriendDialog,
                      width: double.infinity,
                      backgroundColor: AppColors.mainPink,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}