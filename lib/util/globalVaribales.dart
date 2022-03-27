import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import '../screens/addPostScreen.dart';
import '../screens/feedScreen.dart';
import '../screens/profileScreen.dart';
import '../screens/searchScreen.dart';

final homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  AddPostScreen(),
  Center(child: Text("Favorite")),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
