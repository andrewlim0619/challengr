import 'package:challengr/firebase/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  String userUID = '';

	Future<User?> signUp({
		required BuildContext context,
    required String username,
		required String email,
		required String password,
		required String confirmPassword,
	}) async {
		if (!_validateAllSignUpFieldInput(email, password, confirmPassword, context) ||
			!_validateEmail(email, context) ||
			!_validatePassStrength(password, context) ||
			!_validatePassSimilarity(password, confirmPassword, context)) {
			return null;
		}

		try {
			final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
			userUID = cred.user!.uid;

			await FirestoreService().saveSignUpDataToFirestore(
				userUID,
        username,
				email,
			);

			return cred.user;
		} on FirebaseAuthException catch (e) {
			String message;
			if (e.code == 'weak-password') {
				message = 'The password provided is too weak.';
			} else if (e.code == 'email-already-in-use') {
				message = 'An account already exists with that email.';
			} else {
				message = 'An error occurred: ${e.message}';
			}

			Fluttertoast.showToast(msg: message, backgroundColor: Colors.blueGrey);
			return null;
		} catch (e) {
			Fluttertoast.showToast(msg: 'Unexpected error occurred.', backgroundColor: Colors.blueGrey);
			return null;
		}
	}

  Future<User?> logIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (!_validateLogInInput(email, password, context)) {
      return null;
    }

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      return cred.user;
    } on FirebaseAuthException {
      Fluttertoast.showToast(msg: 'There is an incorrect field. Please make sure your email and password is correct.', backgroundColor: Colors.blueGrey);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unexpected error occurred.', backgroundColor: Colors.blueGrey);
    }

    return null;
  }

  Future<void> logOut(BuildContext context) async {
    await _auth.signOut();
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/LoginPage');
  }
  /*
   * Private helper Functions for Sign Up Page
   */
  //Function to ensure that all fields have an input
  bool _validateAllSignUpFieldInput(
    String email, 
    String password, 
    String confPass, 
    BuildContext context) {
    if (email.isEmpty || password.isEmpty || confPass.isEmpty) {
      _displayMessage(context, ("Please answer all fields"));
      return false;
    }

    return true;
  }

  /*
   * Private helper Functions for Sign Up Onboard Page 1
   */
  // //Function to validate password strength
  // bool _validateDateOfBirth(String birthDate, BuildContext context) {
  //   //First validate the input (has to be mm/dd/yy)
  //   final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  //   if (!dateRegex.hasMatch(birthDate)) {
  //     _displayMessage(context, "Date of birth must be in mm/dd/yyyy format.");
  //     return false;
  //   }

  //   List<String> dateParts = birthDate.split('/');
  //   int month = int.parse(dateParts[0]);
  //   int day = int.parse(dateParts[1]);
  //   int year = int.parse(dateParts[2]);

  //   //Second validate the date values
  //   if (month < 1 || month > 12 || day < 1 || day > 31) {
  //     _displayMessage(context, "Invalid date. Please enter a valid date of birth.");
  //     return false;
  //   }

  //   //Third validate to make sure user is at least 18 years of age
  //   DateTime birthDateTime = DateTime(year, month, day);
  //   DateTime currentDate = DateTime.now();
  //   DateTime minAdultBirthDate = DateTime(
  //     currentDate.year - 18, 
  //     currentDate.month, 
  //     currentDate.day,
  //   );

  //   if (birthDateTime.isAfter(minAdultBirthDate)) {
  //     _displayMessage(context, "You must be at least 18 years old.");
  //     return false;
  //   }

  //   return true;
  // }

  //Function to validate email input
  bool _validateEmail(String email, BuildContext context) {
    if (!(email.endsWith('@gmail.com') || email.endsWith('@uw.edu')) && (email.isNotEmpty)) {
      _displayMessage(context, "Only @gmail.com or @uw.edu domains are allowed");
      return false;
    }

    return true;
  }

  //Function to validate password strength
  bool _validatePassStrength(String password, BuildContext context) {
    final hasUpperCase = RegExp(r'[A-Z]');
    final hasLowerCase = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (password.length >= 8 &&
        hasUpperCase.hasMatch(password) &&
        hasLowerCase.hasMatch(password) &&
        hasDigit.hasMatch(password) &&
        hasSpecialChar.hasMatch(password)) {
      return true;
    }

    _displayMessage(context, "Password must be at least 8 characters long, contain an uppercase letter, a lowercase letter, a number, and a special character.");
    return false;
  }

  //Function to validate if the password and confirm password match
  bool _validatePassSimilarity(String password, String confirmPassword, BuildContext context) {
    if (password != confirmPassword) {
      _displayMessage(context, "Passwords do not match");
      return false;
    }

    return true;
  }

  /*
   * Helper Functions for Car Input Details
   */
  //Function to ensure that all fields regarding car details have an input
  bool _validateCarDetailsFieldInput (
    String? carBrand,
    String? carModel,
    String carYear,
    String carColor,
    String carLicensePlate,
    BuildContext context) {
    if (carBrand == null|| carBrand.isEmpty ||
        carModel == null || carModel.isEmpty ||
        carYear.isEmpty || carColor.isEmpty || carLicensePlate.isEmpty) {
      _displayMessage(context, ("Please answer all car details"));
      return false;
    }

    return true;
  }

  /*
   * Helper Functions for Logging In
   */
  bool _validateLogInInput(String email, String password, BuildContext context) {
    // Check if both email and password are empty
    if (email.isEmpty && password.isEmpty) {
      _displayMessage(context, "Please enter your email address and password.");
      return false;
    }

    // Check if email is empty
    if (email.isEmpty) {
      _displayMessage(context, "Please enter your email address.");
      return false;
    }

    // Check if password is empty
    if (password.isEmpty) {
      _displayMessage(context, "Please enter your password.");
      return false;
    }

    return true; // Return true if validation passes
  }

  //Helper function to display a snack bar message
  void _displayMessage(BuildContext context, String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.blueGrey);
  }
}