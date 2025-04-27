import 'package:challengr/firebase/auth_service.dart';
import 'package:challengr/font.dart';
import 'package:challengr/screen/home.dart';
import 'package:challengr/theme.dart';
import 'package:challengr/widgets/authpagelogo.dart';
import 'package:challengr/widgets/custombutton.dart';
import 'package:challengr/widgets/customtextfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController userControllerUsername = TextEditingController();
  final TextEditingController userControllerEmail = TextEditingController();
  final TextEditingController userControllerPassword = TextEditingController();
  final TextEditingController userControllerConfirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainBiege,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  AuthPageLogo(
                    imagePath: 'assets/characters/challengrLogo.png',
                    imageWidth: screenWidth * 0.2,  
                  ),
                  SizedBox(height: screenHeight * 0.05),
            
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome!",
                        style: AppFonts.welcomeText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      //Username
                      TextFieldFormWidget(
                        hiddenText: false,
                        controller: userControllerUsername,
                        label: Text(
                          "Username",
                          style: AppFonts.textFieldProperties,
                        ),
                        hintText: "",
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //Email
                      TextFieldFormWidget(
                        hiddenText: false,
                        controller: userControllerEmail,
                        label: Text(
                          "Email Address",
                          style: AppFonts.textFieldProperties,
                        ),
                        hintText: "",
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //Password
                      TextFieldFormWidget(
                        hiddenText: true,
                        controller: userControllerPassword,
                        label: Text(
                          "Password",
                          style: AppFonts.textFieldProperties,
                        ),
                        hintText: "",
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //Confirm Password
                      TextFieldFormWidget(
                        hiddenText: true,
                        controller: userControllerConfirmPass,
                        label: Text(
                          "Re-enter Password",
                          style: AppFonts.textFieldProperties,
                        ),
                        hintText: "",
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Button with full width
                      SizedBox(
                        width: double.infinity,  // Ensure button takes full width
                        child: CustomButton(
                          text: "Sign Up",
                          width: screenWidth,
                          backgroundColor: AppColors.mainOrange,
                          onPressed: () async {
                            final accountCreatedSuccessfully = await AuthService().signUp(
                              context: context,
                              username: userControllerUsername.text,
                              email: userControllerEmail.text,
                              password: userControllerPassword.text,
                              confirmPassword: userControllerConfirmPass.text,
                            );

                            if (accountCreatedSuccessfully != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: AppFonts.textFieldProperties,
                          children: [
                            TextSpan(
                              text: "Log In!",
                              style: AppFonts.textFieldProperties.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/LoginPage',
                                    (route) => false,
                                );
                              },
                            ),
                          ],
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
    );
  }
}
