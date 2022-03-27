import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/firestoreMethods.dart';
import 'package:instaclone/util/colors.dart';

import '../resources/authMethods.dart';
import '../widgets/followButton.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String profileImage =
      "https://i.pinimg.com/originals/0b/93/09/0b9309cf2dd079c998a5414e32a04618.gif";
  String description = "";
  int postLength = 0;
  int following = 0;
  int followers = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      // ! Get Posts Length

      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("User Id", isEqualTo: widget.uid)
          .get();

      setState(() {
        username = snap["Username"];
        profileImage = snap["Photo URL"];
        description = snap["Bio"];
        postLength = postSnap.docs.length;
        followers = snap["Followers"].length;
        following = snap["Following"].length;
        isFollowing =
            snap["Followers"].contains(FirebaseAuth.instance.currentUser!.uid);
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Not Working");
    }
  }

  void clickButton() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(username),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  profileImage,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLength, "Posts"),
                                    buildStatColumn(followers, "Followers"),
                                    buildStatColumn(following, "Following"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? FollowButton(
                                      text: "Sign Out",
                                      backGroundColor: mobileBackgroundColor,
                                      textColor: primaryColor,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await AuthMethods().signOut();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) => const LoginScreen(),) 
                                        );
                                      },
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          text: "Unfollow",
                                          backGroundColor: Colors.white,
                                          textColor: Colors.black,
                                          borderColor: Colors.white,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.uid,
                                            );
                                            clickButton();
                                          },
                                        )
                                      : FollowButton(
                                          text: "Follow",
                                          backGroundColor: blueColor,
                                          textColor: Colors.white,
                                          borderColor: blueColor,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.uid,
                                            );
                                            clickButton();
                                          },
                                        ),
                            ],
                          ),
                          Positioned(
                            child: Text(description),
                            left: 0,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("User Id", isEqualTo: widget.uid)
                      .get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data.docs[index];
                        return Container(
                          child: Image(
                              image: NetworkImage(
                                snap["Photo URL"],
                              ),
                              fit: BoxFit.cover),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
