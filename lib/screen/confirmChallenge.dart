import 'package:flutter/material.dart';
import 'package:challengr/font.dart';
import 'package:challengr/theme.dart';
import 'package:challengr/widgets/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmChallengePage extends StatefulWidget {
  final String opponentId;
  final String habit;
  final String description;
  final String duration;
  final String wagerType;
  final String wagerValue;

  const ConfirmChallengePage({
    Key? key,
    required this.opponentId,
    required this.habit,
    required this.description,
    required this.duration,
    required this.wagerType,
    required this.wagerValue,
  }) : super(key: key);

  @override
  _ConfirmChallengePageState createState() => _ConfirmChallengePageState();
}

class _ConfirmChallengePageState extends State<ConfirmChallengePage> {
  bool _saving = false;

  Future<Map<String, String>> _loadUsernames() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final meDoc = FirebaseFirestore.instance.collection('users').doc(uid).get();
    final oppDoc = FirebaseFirestore.instance.collection('users').doc(widget.opponentId).get();
    final results = await Future.wait([meDoc, oppDoc]);
    final meName = results[0].data()?['username'] as String? ?? 'You';
    final oppName = results[1].data()?['username'] as String? ?? 'Opponent';
    return {'me': meName, 'opp': oppName};
  }

  Future<void> _submitChallenge() async {
    setState(() => _saving = true);
    final user = FirebaseAuth.instance.currentUser!;
    final requestRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.opponentId)
        .collection('requests');
    await requestRef.add({
      'from': user.uid,
      'habit': widget.habit,
      'description': widget.description,
      'duration': widget.duration,
      'wagerType': widget.wagerType,
      'wagerValue': widget.wagerValue,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppFonts.parText.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: AppFonts.parText.copyWith(fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mainBiege,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      'new',
                      style: AppFonts.heading2.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'CHALLENGE',
                      style: AppFonts.heading1.copyWith(
                        color: const Color(0x63EC612A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Text(
                      'CHALLENGE',
                      style: AppFonts.heading2.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 85),
                    child: Text(
                      'summary',
                      style: AppFonts.heading2.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<Map<String, String>>(
              future: _loadUsernames(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                final names = snap.data!;
                return Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/characters/mainPinkCharacter.png',
                              width: screenWidth * 0.2,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            SizedBox(
                              width: screenWidth * 0.4,
                              height: screenWidth * 0.4,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 50,
                                    left: 0,
                                    right: 50,
                                    child: Text(
                                      names['me']!,
                                      textAlign: TextAlign.center,
                                      style: AppFonts.parText.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Positioned(
                                    top: (screenWidth * 0.4) / 2 - 15,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      'VS',
                                      textAlign: TextAlign.center,
                                      style: AppFonts.heading2.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 50,
                                    left: 50,
                                    right: 0,
                                    child: Text(
                                      names['opp']!,
                                      textAlign: TextAlign.center,
                                      style: AppFonts.parText.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
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

                        _buildRow('Habit', widget.habit),
                        _buildRow('Description', widget.description),
                        _buildRow('Duration', widget.duration),
                        _buildRow('Wager (${widget.wagerType})', widget.wagerValue),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _saving
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Back',
                                      onPressed: () => Navigator.of(context).pop(),
                                      width: double.infinity,
                                      backgroundColor: AppColors.mainPink,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Confirm & Send',
                                      onPressed: _submitChallenge,
                                      width: double.infinity,
                                      backgroundColor: AppColors.mainOrange,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
