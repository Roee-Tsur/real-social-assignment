import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? email;
  String? displayName;
  List places;
  String id;

  User({required this.id, this.email, this.displayName, required this.places});

  static User fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      throw "error in fromFirestore User";
    }
    return User(
        id: snapshot.id,
        places: data[UserFieldNames.places],
        displayName: data[UserFieldNames.displayName],
        email: data[UserFieldNames.email]);
  }

  static Map<String, Object?> toFirestore(User? user, SetOptions? options) {
    if (user == null) {
      return {};
    }
    return {
      UserFieldNames.places: user.places,
      UserFieldNames.displayName: user.displayName,
      UserFieldNames.email: user.email
    };
  }
}

class UserFieldNames {
  static const id = 'id';
  static const places = 'places';
  static const displayName = 'displayName';
  static const email = 'email';
}
