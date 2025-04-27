import 'package:challengr/screen/confirmChallenge.dart';
import 'package:challengr/widgets/custombutton.dart';
import 'package:challengr/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:challengr/font.dart';
import 'package:challengr/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartChallenge extends StatefulWidget {
  const StartChallenge({Key? key}) : super(key: key);

  @override
  State<StartChallenge> createState() => _StartChallengeState();
}

class _StartChallengeState extends State<StartChallenge> {
  String? _selectedOpponent;
  String _wagerType = 'Money';

  final TextEditingController userControllerHabit = TextEditingController();
  final TextEditingController userControllerHabitDesc = TextEditingController();
  final TextEditingController userControllerDuration = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  Future<List<Map<String, String>>> _loadFriendList(List<dynamic> ids) async {
    final futures = ids.map((id) =>
        FirebaseFirestore.instance.collection('users').doc(id as String).get());
    final docs = await Future.wait(futures);
    return docs
        .where((doc) => doc.exists)
        .map((doc) {
          final data = doc.data()! as Map<String, dynamic>;
          return {'id': doc.id, 'username': data['username'] as String};
        })
        .toList();
  }

  Widget _buildWagerButton(String label) {
    final selected = _wagerType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _wagerType = label),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? AppColors.mainOrange : const Color(0xFFDEDBD6),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : Colors.grey,
              fontSize: 15,
              fontFamily: 'Karla',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    return Scaffold(
      backgroundColor: AppColors.mainBiege,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: [
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
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'CHALLENGE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'new',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Choose your opponent', style: AppFonts.parText),
                    SizedBox(height: screenHeight * 0.01),
                    StreamBuilder<DocumentSnapshot>(
                      stream: userRef.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final friendIds = List<dynamic>.from(data['friendList'] ?? []);
                        return FutureBuilder<List<Map<String, String>>>(
                          future: _loadFriendList(friendIds),
                          builder: (context, friendsSnap) {
                            if (friendsSnap.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final friends = friendsSnap.data ?? [];
                            return Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainBlack),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Select opponent'),
                                  value: _selectedOpponent,
                                  items: friends.map((f) {
                                    return DropdownMenuItem<String>(
                                      value: f['id'],
                                      child: Text(f['username']!),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() => _selectedOpponent = val),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFieldFormWidget(
                      hiddenText: false,
                      controller: userControllerHabit,
                      label: Text('Habit to Track', style: AppFonts.textFieldProperties),
                      hintText: 'eg. Reading 10 pages a day',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFieldFormWidget(
                      hiddenText: false,
                      controller: userControllerHabitDesc,
                      label: Text('Challenge Description', style: AppFonts.textFieldProperties),
                      hintText: 'e.g. Can read a book of your choice',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFieldFormWidget(
                      hiddenText: false,
                      controller: userControllerDuration,
                      label: Text('Duration', style: AppFonts.textFieldProperties),
                      hintText: 'e.g. 30 Days',
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text('Wager', style: AppFonts.textFieldProperties),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        _buildWagerButton('Money'),
                        SizedBox(width: screenWidth * 0.02),
                        _buildWagerButton('Other'),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (_wagerType == 'Money') ...[
                      TextFieldFormWidget(
                        hiddenText: false,
                        controller: _moneyController,
                        label: Text('Enter Money Wager', style: AppFonts.textFieldProperties),
                        hintText: 'e.g. 10 Dollars',
                      ),
                    ] else ...[
                      TextFieldFormWidget(
                        hiddenText: false,
                        controller: _otherController,
                        label: Text('Enter Punishment/Dare', style: AppFonts.textFieldProperties),
                        hintText: 'e.g. Do 10 push-ups',
                      ),
                    ],
                    SizedBox(height: screenHeight * 0.07),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Back',
                            onPressed: () => Navigator.of(context).pushNamed('/HomePage'),
                            width: double.infinity,
                            backgroundColor: AppColors.mainPink,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: CustomButton(
                            text: 'Next',
                            onPressed: () {
                              if (_selectedOpponent == null) return; // guard

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ConfirmChallengePage(
                                    opponentId: _selectedOpponent!,
                                    habit: userControllerHabit.text,
                                    description: userControllerHabitDesc.text,
                                    duration: userControllerDuration.text,
                                    wagerType: _wagerType,
                                    wagerValue: _wagerType == 'Money'
                                      ? _moneyController.text
                                      : _otherController.text,
                                  ),
                                ),
                              );
                            },

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
            ),
          ],
        ),
      ),
    );
  }
}
