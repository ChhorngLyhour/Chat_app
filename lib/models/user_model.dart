// ignore_for_file: unnecessary_this, dead_code

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String photoURL;
  final bool inOnline;
  final DateTime lastSeen;
  final DateTime createAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL = "",
    this.inOnline = false,
    required this.lastSeen,
    required this.createAt,
    required bool isOnline, // kept it for compatibility, even if unused
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'inOnline': inOnline,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'createAt': createAt.millisecondsSinceEpoch,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
      isOnline: map['inOnline'] ?? false,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] ?? 0),
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] ?? 0),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isOnline: isOnline ?? this.inOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createAt: createdAt ?? this.createAt,
    );
  }
}
