import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:uuid/uuid.dart';

class StorageMethods {
// ignore: prefer_final_fields
  FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ! Add Image To Firebase Storage
  // ? Upload Our Image To Firebase Storage Then Return The Download URL
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id); 
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapShot = await uploadTask;
    String downloadURL = await snapShot.ref.getDownloadURL();
    return downloadURL;
  }
}
