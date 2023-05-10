import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  ///class responsible for all things related to authentication
  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  final _firestore = FirebaseFirestore.instance;

  late CollectionReference<User> _usersCollection;

  void init() {
    _usersCollection = _firestore.collection("users").withConverter(
        fromFirestore: User.fromFirestore, toFirestore: User.toFirestore);
  }

  listenToUser(String userId) {
    _usersCollection.doc(userId).snapshots().listen((event) {
    });
  }
}
