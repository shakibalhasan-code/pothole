import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices extends GetxService {
  late FirebaseAuth auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? currentUser() {
    return auth.currentUser;
  }

  @override
  void onInit() async {
    super.onInit();
    // Initialize Firebase services here
    await fireInit();
  }

  Future<FirebaseServices> fireInit() async {
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
    return this;
  }

  Future<void> signInGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      // User is signed in
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  void onReady() {
    super.onReady();
    // Perform any actions after the service is ready
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources if needed
  }
}
