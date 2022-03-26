import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/util/colors.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/userProvider.dart';
import '../resources/firestoreMethods.dart';
import '../util/utils.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;

  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Select Image"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose From Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String result = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      setState(() {
        _isLoading = false;
      });
      if (result == "Success") {
        showAlertDialog("Post Uploaded Successfully", context , false);
        clearImage() ; 
      } else {
        showAlertDialog("Post Could Not Upload", context , true);
      }
    } catch (e) {}
  }

  void clearImage() {
    setState(() {
      _file = null ; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectImage(context);
              },
              icon: const Icon(Icons.upload),
            ),
          )
        : _isLoading
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      clearImage() ; 
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text("Post To"),
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () {
                        postImage(user.userID, user.username, user.photoURL);
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                                hintText: "Write A Caption ...",
                                border: InputBorder.none),
                            maxLines: 8,
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
  }
}
