import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? email;
  String? displayName;
  List places;

  User({this.email, this.displayName, required this.places});

  static User fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      throw "error in fromFirestore User";
    }
    return User(
        places: data["places"],
        displayName: data["displayName"],
        email: data["email"]);
  }

  static Map<String, Object?> toFirestore(User? user, SetOptions? options) {
    if (user == null) {
      return {};
    }
    return {
      "places": user.places,
      "displayName": user.displayName,
      "email": user.email
    };
  }
}
