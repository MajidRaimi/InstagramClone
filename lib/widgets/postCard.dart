import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/userProvider.dart';
import '../resources/firestoreMethods.dart';
import '../screens/commentsScreen.dart';
import '../util/colors.dart';
import 'likeAmimation.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);
  final Map<String, dynamic> snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  @override
  void initState() {
    super.initState();
    // getComments();
  }

  // void getComments() async {
  //   QuerySnapshot snap = await FirebaseFirestore.instance
  //       .collection("pots")
  //       .doc(widget.snap["Post Id"])
  //       .collection("comments")
  //       .get();

  //   setState(() {
  //     commentLength = snap.docs.length;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const CircularProgressIndicator();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        color: mobileBackgroundColor,
        child: Column(
          children: [
            // ! Header Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap["Profile Image"]),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    widget.snap["Username"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  children: [
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          await FirestoreMethods().deletePost(
                                              widget.snap["Post Id"]);
                                        },
                                        child: const Text("Delete Post"),
                                      ),
                                    ),
                                  ],
                                  shrinkWrap: true,
                                ),
                              );
                            });
                      },
                      icon: const Icon(Icons.more_vert))
                ],
              ),
            ),
            // ! Image Section
            GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                    widget.snap["Post Id"], user!.userID, widget.snap["Likes"]);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              onTap: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap["Photo URL"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                        child: const Icon(Icons.favorite,
                            color: Colors.white, size: 100),
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 300),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        }),
                  )
                ],
              ),
            ),
            // ! Like + Comment Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  LikeAnimation(
                    isAnimating: widget.snap['Likes'].contains(user!.userID),
                    child: IconButton(
                      onPressed: () async {
                        await FirestoreMethods().likePost(
                            widget.snap["Post Id"],
                            user!.userID,
                            widget.snap["Likes"]);
                      },
                      icon: widget.snap['Likes'].contains(user!.userID)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border_outlined),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.comment_outlined, size: 24),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, size: 24),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_outline, size: 24),
                  ),
                ],
              ),
            ),
            // ! Description + Number Of Comments Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.snap["Likes"].length} Likes",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: widget.snap["Username"]),
                            const TextSpan(text: "   "),
                            TextSpan(
                              text: widget.snap["Description"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "View All ${commentLength} Comments",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: secondaryColor),
                      ),
                    ),
                  ),
                  Text(DateFormat.yMMMd()
                      .format(widget.snap["Date Published"].toDate()))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
