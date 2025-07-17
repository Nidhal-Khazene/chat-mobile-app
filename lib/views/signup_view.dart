import 'package:chat_app/cubits/signup_cubit/signup_cubit.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../cubits/chat_cubit/chat_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import 'chat_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});
  static String id = "SignupView";

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          isLoading = true;
        } else if (state is SignupSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatView.id, arguments: email);
          isLoading = false;
        } else if (state is SignupFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder:
          (context, state) => ModalProgressHUD(
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
                            "Create an account",
                            style: TextStyle(
                              color: Color(0xff00ff99),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'dubai',
                            ),
                          ),
                          const Text(
                            "Connect and chat with your friends today!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: "dubai",
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
                            BlocProvider.of<SignupCubit>(
                              context,
                            ).registerUser(email: email!, password: password!);
                          }
                        },
                        title: "Signup",
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login',
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
