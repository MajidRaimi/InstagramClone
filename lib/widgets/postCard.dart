import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/userProvider.dart';
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

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        color: mobileBackgroundColor,
        child: Column(
          children: [
            // ! Header Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                                  children: const [
                                    Center(
                                      child: Text("Delete Post"),
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
              onTap: ()  {
                setState(()  {
                  isLikeAnimating = true;
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
                    isAnimating: widget.snap['Likes'].contains(user.userID),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_outline, size: 24),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined, size: 24),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, size: 24),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_outline, size: 24),
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
                        "View All 200 Comments",
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
