import 'package:challengr/screen/acceptChallenge.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:challengr/theme.dart';
import 'package:challengr/font.dart';
import 'package:challengr/widgets/custombutton.dart';

class ViewRequests extends StatefulWidget {
  const ViewRequests({Key? key}) : super(key: key);

  @override
  _ViewRequestsState createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.mainBiege,),
      backgroundColor: AppColors.mainBiege,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'CHALLENGE',
                    style: AppFonts.heading1.copyWith(
                      color: AppColors.mainPink.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    child: Text('CHALLENGE', style: AppFonts.heading2.copyWith(fontWeight: FontWeight.bold)),
                  ),                  
                  Positioned(
                    bottom: 10,
                    child: Text('requests', style: AppFonts.heading2),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_uid)
                    .collection('requests')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(child: Text('No requests', style: AppFonts.parText));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final req = docs[index];
                      final isEven = index % 2 == 0;
                      final charAsset = isEven
                          ? 'assets/characters/mainOrangeCharacter.png'
                          : 'assets/characters/mainPinkCharacter.png';
                      final buttonColor = isEven ? AppColors.mainOrange : AppColors.mainPink;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(req['from'] as String)
                            .get(),
                        builder: (context, userSnap) {
                          final fromName = (userSnap.hasData && userSnap.data!.exists)
                              ? (userSnap.data!.data() as Map<String, dynamic>)['username'] as String
                              : 'Unknown';
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Image and title
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        charAsset,
                                        width: 60,
                                        height: 60,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '$fromName is challenging you to:',
                                          style: AppFonts.heading2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Details
                                  Row(
                                    children: [
                                      const Icon(Icons.book, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          req['habit'] as String,
                                          style: AppFonts.parText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'For: ${req['duration']}',
                                          style: AppFonts.parText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Wager: ${req['wagerValue']}',
                                          style: AppFonts.parText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Button
CustomButton(
  text: 'Accept Challenge',
  onPressed: () async {
    final meId      = FirebaseAuth.instance.currentUser!.uid;
    final oppId     = req['from'] as String;        // from your FutureBuilder scope
    final requestId = docs[index].id;               // the request document ID
    final data      = req.data() as Map<String, dynamic>;

    final batch = FirebaseFirestore.instance.batch();

    // 1) Remove the request
    final reqRef = FirebaseFirestore.instance
      .collection('users').doc(meId)
      .collection('requests').doc(requestId);
    batch.delete(reqRef);

    // 2) Create match record for me
    final matchData = {
      'otherUser': oppId,
      'habit': data['habit'],
      'description': data['description'],
      'duration': data['duration'],
      'wagerType': data['wagerType'],
      'wagerValue': data['wagerValue'],
      'startedAt': FieldValue.serverTimestamp(),
      'status': 'active',
    };
    final myMatchRef = FirebaseFirestore.instance
      .collection('users').doc(meId)
      .collection('matchList').doc(oppId);
    batch.set(myMatchRef, matchData);

    // 3) Mirror for opponent
    final oppMatchRef = FirebaseFirestore.instance
      .collection('users').doc(oppId)
      .collection('matchList').doc(meId);
    batch.set(oppMatchRef, {
      ...matchData,
      'otherUser': meId,
    });

    await batch.commit();

    // 4) Navigate to your AcceptChallengePage
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AcceptChallengePage(),
      ),
    );
  },
  width: double.infinity,
  backgroundColor: buttonColor,
  textColor: Colors.white,
),

                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
