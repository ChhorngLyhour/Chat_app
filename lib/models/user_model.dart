import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String photoURL;
  final bool isOnline;
  final DateTime createAt;
  final DateTime? lastSeen; // ← add this

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.isOnline,
    required this.createAt,
    this.lastSeen, // ← optional
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'] ?? '',
      isOnline: map['isOnline'] ?? false,
      createAt: map['createAt'] != null
          ? (map['createAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastSeen: map['lastSeen'] != null
          ? (map['lastSeen'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'isOnline': isOnline,
      'createAt': Timestamp.fromDate(createAt),
      if (lastSeen != null) 'lastSeen': Timestamp.fromDate(lastSeen!),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    bool? isOnline,
    DateTime? createAt,
    DateTime? lastSeen,
  }) {
    return UserModel(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      isOnline: isOnline ?? this.isOnline,
      createAt: createAt ?? this.createAt,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
