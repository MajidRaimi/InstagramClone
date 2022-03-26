import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/storageMethods.dart';
import 'package:uuid/uuid.dart';

import '../model/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ! Upload Post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String result = "Some Error Occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        userID: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        photoURL: photoUrl,
        profImage: profileImage,
        likes: [],
      );

      await _firestore.collection("posts").doc(postId).set(post.toJson());
      result = "Success";
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
