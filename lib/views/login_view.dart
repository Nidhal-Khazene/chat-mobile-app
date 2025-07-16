import 'dart:developer';

import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/views/signup_view.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import 'chat_view.dart';

class LoginView extends StatefulWidget {
  static String id = "LoginView";

  const LoginView({super.key});

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
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          Navigator.pushNamed(context, ChatView.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      child: ModalProgressHUD(
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
                        BlocProvider.of<LoginCubit>(
                          context,
                        ).loginUser(email: email!, password: password!);
                      } else {
                        log("the data does not validate.");
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
      ),
    );
  }
}
