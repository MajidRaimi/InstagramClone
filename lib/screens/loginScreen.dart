import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/screens/signUpScreen.dart';
import 'package:instaclone/util/colors.dart';
import 'package:instaclone/widgets/textFieldInput.dart';

import '../resources/authMethods.dart';
import '../util/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods()
        .loginUser(_emailController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (result == "Logged In User Successfully") {
      print("Logged In Successfully"); 
    } else {
      showAlertDialog(result, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ! SVG Image
                SvgPicture.asset(
                  "assets/instagramLogo.svg",
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(height: _height / 4),
                // ! Email Text Field
                TextFieldInput(
                  hintText: "Enter Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: _height / 30),
                // ! Password Text Field
                TextFieldInput(
                  hintText: "Enter Password",
                  isPass: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: _height / 20,
                ),
                // ! Login Button
                GestureDetector(
                  onTap: () async {
                    await loginUser();
                  },
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 64.0, vertical: 16),
                            child: Text("Login"),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: blueColor,
                          ),
                        ),
                ),
                SizedBox(
                  height: _height / 30,
                ),
                // ! Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't Have An Account ? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
