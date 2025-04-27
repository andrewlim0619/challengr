import 'package:challengr/firebase/auth_service.dart';
import 'package:challengr/font.dart';
import 'package:challengr/theme.dart';
import 'package:challengr/widgets/authpagelogo.dart';
import 'package:challengr/widgets/custombutton.dart';
import 'package:challengr/widgets/customtextfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}  

class LoginPageState extends State<LoginPage> {
  final TextEditingController userControllerEmail = TextEditingController();
  final TextEditingController userControllerPassword = TextEditingController();
  
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
                  SizedBox(height: screenHeight * 0.1),

                  Animate(
                    effects: [
                      SlideEffect(
                        begin: Offset(-1.5, 0),
                        end: Offset(0, 0),
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut, 
                      ),
                    ],

                    child: Text(
                      "Welcome Back :)",
                      style: AppFonts.welcomeText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  TextFieldFormWidget(
                    hiddenText: false,
                    controller: userControllerEmail,
                    label: Text(
                      "Email Address",
                      style: AppFonts.textFieldProperties,
                    ),
                    hintText: "",
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  TextFieldFormWidget(
                    hiddenText: true,
                    controller: userControllerPassword,
                    label: Text(
                      "Password",
                      style: AppFonts.textFieldProperties,
                    ),
                    hintText: "",
                  ),
                  SizedBox(height: screenHeight * 0.04), 

                  CustomButton(
                    text: "Log In",
                    width: screenWidth,
                    backgroundColor: AppColors.mainOrange,
                    onPressed: () async {
                      final logInSuccessfully = await AuthService().logIn(
                        context: context,
                        email: userControllerEmail.text,
                        password: userControllerPassword.text
                      );

                      if (logInSuccessfully != null) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/HomePage',
                          (route) => false,
                        );
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  RichText(
                    text: TextSpan(
                      text: "Not a returning user? ",
                      style: AppFonts.textFieldProperties,
                      children: [
                        TextSpan(
                          text: "Sign Up!",
                          style: AppFonts.textFieldProperties.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/SignUpPage',
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
