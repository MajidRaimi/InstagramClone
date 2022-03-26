import 'dart:math';
import 'dart:typed_data';

import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/resources/authMethods.dart';
import 'package:instaclone/util/colors.dart';
import 'package:instaclone/util/utils.dart';
import 'package:instaclone/widgets/textFieldInput.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsiveLayoutScreen.dart';
import '../responsive/webScreenLayout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  backgroundImage() {
    if (_image != null) {
      return MemoryImage(_image!);
    }
    return const NetworkImage(
      "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png",
    );
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_image == null) {
      String result = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          bio: _bioController.text,
          file: _image!);
    }

    String result = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (result != 'Added User Successfully') {
      showAlertDialog(result, context , true);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            );
          },
        ),
      );
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
                // ! Circular Image Selector
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: backgroundImage(),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () async {
                          await selectImage();
                        },
                        child: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                      right: 0,
                      bottom: 0,
                    ),
                  ],
                ),
                SizedBox(height: _height / 12),
                // ! Username Text Field
                TextFieldInput(
                  hintText: "Enter Username",
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: _height / 30),
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
                // ! Bio Text Field
                TextFieldInput(
                  hintText: "Enter Bio",
                  controller: _bioController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: _height / 30), // ! Sign Up Button
                GestureDetector(
                  onTap: () async {
                    await signUpUser();
                  },
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 64.0, vertical: 16),
                            child: Text("Sign Up"),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: blueColor),
                        ),
                ),
                SizedBox(
                  height: _height / 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
