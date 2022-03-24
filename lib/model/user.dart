import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User(
      {required this.username,
      required this.email,
      required this.userID,
      required this.bio,
      required this.password,
      required this.photoURL,
      required this.followers,
      required this.following});

  final String username;
  final String email;
  final String userID;
  final String bio;
  final String password;
  final String photoURL;
  final List followers;
  final List following;

  Map<String, dynamic> toJson() => {
        'Username': username,
        'Email': email,
        'User Id': userID,
        'Bio': bio,
        'Password': password,
        'Followers': [],
        'Following': [],
        "Photo URL": photoURL
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        followers: snapshot['Followers'],
        following: snapshot['Following'],
        bio: snapshot['Bio'],
        email: snapshot["Email"],
        password: snapshot['Password'],
        photoURL: snapshot['Photo URL'],
        userID: snapshot['User Id'],
        username: snapshot['Username']);
  }
}
