import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihk_ap1_prep/services/notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      NotificationService.scheduleDailyLearningReminder(user.uid);
    }
    return cred;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    final cred = await _auth.signInWithPopup(provider);
    final user = cred.user;
    if (user != null) {
      NotificationService.scheduleDailyLearningReminder(user.uid);
    }
    return cred;
  }

  Future<void> logout() => _auth.signOut();
}
