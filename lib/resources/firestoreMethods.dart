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

  // ! Will Add To User Id To List Of Likes
  Future<void> likePost(String postId, String userId, List likes) async {
    try {
      // ! If You Already Liked Remove Your Like
      if (likes.contains(userId)) {
        await _firestore.collection("posts").doc(postId).update({
          "Likes": FieldValue.arrayRemove([userId])
        });
        // ! If Its Your First Time Liking Add User Id To Like List Of The Post
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "Likes": FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String userId,
      String profilePic, String username) async {
    String result = "Error";

    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1().toString();
        // ! Adding A New Collection Inside A Collection
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "username": username,
          "userId": userId,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now()
        });
      }

      result = "Worked";
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  // ! Delete Post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete() ; 
    } catch (e) {}
  }
}
