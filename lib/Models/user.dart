import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nickname;
  final String photoUrl;
  final String createdAt;
  final String aboutMe;

  User({
    this.id,
    this.nickname,
    this.photoUrl,
    this.createdAt,
    this.aboutMe
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      photoUrl: doc['photoUrl'],
      nickname: doc['nickname'],
      createdAt: doc['createdAt'],
      aboutMe: doc['aboutMe'],
    );
  }
}
