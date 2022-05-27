import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String firstName;
  String secondName;



  UserModel({required this.firstName, required this.email, required this.uid, required this.secondName});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      secondName: map['secondName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName' : secondName,
    };
  }

  static Future<UserModel?> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (userDocument != null && userDocument.exists) {
      return UserModel.fromMap(userDocument.data());
    } else {
      return null;
    }
  }

  static Future<UserModel> updateCurrentUser(UserModel user) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(user.toMap())
        .then((value) {
      return user;
    });
  }
}
