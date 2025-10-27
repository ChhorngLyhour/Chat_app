import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign In
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        // Set online status in Firestore
        await _firestoreService.updateUserOnlineStatus(user.uid, true);
        return await _firestoreService.getUser(user.uid);
      }
      return null;
    } catch (e) {
      throw Exception('Failed To Sign In: ${e.toString()}');
    }
  }

  // Register
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(displayName);

        // Create UserModel with lastSeen and isOnline
        final userModel = UserModel(
          id: user.uid,
          displayName: displayName,
          email: email,
          photoURL: '',
          isOnline: true,
          createAt: DateTime.now(),
          lastSeen: DateTime.now(),
        );

        await _firestoreService.createUser(userModel);
        return userModel;
      }
      return null;
    } catch (e) {
      throw Exception('Failed To Register: ${e.toString()}');
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed To Send Password Reset Email: ${e.toString()}');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      if (currentUser != null) {
        await _firestoreService.updateUserOnlineStatus(currentUserId!, false);
      }
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed To Sign Out: ${e.toString()}');
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestoreService.deleteUser(user.uid);
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed To Delete Account: ${e.toString()}');
    }
  }

  // ✅ Add this missing method to fix "getUserById" error
  Future<UserModel?> getUserById(String userId) async {
    return await _firestoreService.getUser(userId);
  }
}
