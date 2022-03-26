import "package:flutter/material.dart";

import '../screens/addPostScreen.dart';
import '../screens/feedScreen.dart';

final homeScreenItems = [
  FeedScreen(),
  Center(child: Text("Search")),
  AddPostScreen(),
  Center(child: Text("Favorite")),
  Center(child: Text("Settings")),
];
