import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/firestoreMethods.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/userProvider.dart';
import '../util/colors.dart';
import '../widgets/commentCard.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);
  final snap;
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    print(user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text("Comments"),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
                radius: 18,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: "Comment As ${user.username}",
                      border: InputBorder.none),
                ),
              ),
              IconButton(
                onPressed: () async {
                  String result = await FirestoreMethods().postComment(
                      widget.snap["Post Id"],
                      _commentController.text,
                      widget.snap["User Id"],
                      user.photoURL,
                      user.username);
                  print(result);
                  print("${user.username} Says : ${_commentController.text} ");
                  _commentController.clear();
                  // ! To Close The Keyboard
                  FocusScope.of(context).unfocus();
                },
                icon: const Icon(Icons.send),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["Post Id"])
            .collection("comments")
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data! == null) {
            return const Center(
              child: Text(
                "Not Comments Found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
              // ! Cheap Trick
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data()));
        },
      ),
    );
  }
}
