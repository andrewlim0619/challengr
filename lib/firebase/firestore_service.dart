import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<void> saveSignUpDataToFirestore(
    String uid, 
    String username,
    String email,
  ) async {
    //Storing all information to the database
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    final newUser = {
      'email': email,
      'username': username,
      'friendList': <String>[],  // initialize with empty list of friend UIDs
      'matchList': <String>[],  // initialize with empty list of friend UIDs
    };

    try {
      await firestore.collection('users').doc(uid).set(newUser);
    } catch (e) {
      return;
    }
  }
}