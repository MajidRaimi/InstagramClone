import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  const Post(
      {required this.username,
      required this.postId,
      required this.userID,
      required this.description,
      required this.datePublished,
      required this.photoURL,
      required this.profImage,
      required this.likes});

  final String description;
  final String userID;
  final String username;
  final String postId;
  final datePublished;
  final String photoURL;
  final String profImage;
  final likes;

  Map<String, dynamic> toJson() => {
        "Description": description,
        "User Id": userID,
        "Username": username,
        "Post Id": postId,
        "Date Published": datePublished,
        "Profile Image": profImage,
        "Likes": likes,
        "Photo URL": photoURL,
      };



  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['Username'],
      userID: snapshot['User Id'],
      description: snapshot['Description'],
      postId: snapshot['Post Id'],
      datePublished: snapshot['Date Published'],
      profImage: snapshot['Profile Image'],
      likes: snapshot['Likes'],
      photoURL: snapshot['Photo URL'],
    );
  }

}
