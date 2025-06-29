import 'package:chat_app/constants.dart';
import 'package:chat_app/views/signup_view.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_form_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String id = "LoginView";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? password;
  String? email;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 75),
                Image.asset("assets/images/scholar.png", height: 100),
                const SizedBox(height: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "MindBridge Chat",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'dubai',
                        fontSize: 32,
                      ),
                    ),
                    const Text(
                      "Hi, Welcome Back! 👋",
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'dubai',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 8),
                CustomFormTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: "example@gmail.com",
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 8),
                CustomFormTextField(
                  onChanged: (data) {
                    password = data;
                  },
                  icon: Icons.visibility_off,
                  inverseIcon: Icons.visibility,
                  hintText: "enter your password",
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        showSnackBar(
                          context,
                          "Successfully signed in with email link!",
                        );
                        Navigator.pushNamed(
                          context,
                          "ChatView",
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(context, "User not found.");
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context, "Wrong password.");
                        } else {
                          showSnackBar(
                            context,
                            "Authentication failed: ${e.message}",
                          );
                        }
                      } catch (e) {
                        showSnackBar(context, "Login failed: ${e.toString()}");
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                  title: "Login",
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignupView.id);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xff00ff99),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "dubai",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential useCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
