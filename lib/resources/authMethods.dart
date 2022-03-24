import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import "package:instaclone/model/user.dart" as model;
import 'package:instaclone/resources/storageMethods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap (snap); 
  }

  // ! Sign Up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String result = "Could Not Work";

    try {
      if (email.isNotEmpty &&
              password.isNotEmpty &&
              username.isNotEmpty &&
              bio.isNotEmpty
          // && file != null
          ) {
        // ! Register The User
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoURL = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);

        model.User user = model.User(
            username: username,
            userID: credential.user!.uid,
            email: email,
            bio: bio,
            password: password,
            photoURL: photoURL,
            followers: [],
            following: []);

        // ! Add User To Database
        // * Will Make The User Document Id Equals To The User Credential Uid And That Will Always Be Random
        // ? So We Can Access The Collection Faster And Easier
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());

        // * Old School
        // await _firestore.collection('users').doc(credential.user!.uid).set({
        //   'Username': username,
        //   'Email': email,
        //   'User Id': credential.user!.uid,
        //   'Bio': bio,
        //   'Password': password,
        //   'Followers': [],
        //   'Following': [],
        //   "Photo URL": photoURL
        // });

        result = "Added User Successfully";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        result = "The Email Is Badly Formatted";
      }
      if (err.code == 'weak-password') {
        result = "The Password Must Be At Least 6 Characters";
      }
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  // ! Login User
  Future<String> loginUser(String email, String password) async {
    String result = "Could Not Work";

    try {
      if (!(email.isEmpty || password.isEmpty)) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "Logged In User Successfully";
      } else {
        result = "Please Enter All The Fields";
      }
    } catch (err) {
      result = err.toString();
    }

    print("The Result Is : " + result);
    return result;
  }
}
