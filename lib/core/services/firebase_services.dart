import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseServices extends GetxService {
  late FirebaseAuth auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AppleAuthProvider _appleSignIn = AppleAuthProvider();

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
    }
  }

  Future<void> signInApple() async {
    try {
      // Step 1: Get Apple ID credentials with webAuthenticationOptions
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId:
              'com.decodersfamily.jourapothole', // Replace with your App's Client ID (App's Bundle Identifier)
          redirectUri: Uri.parse(
            'https://www.joinventureai.com/callback',
          ), // Replace with your Redirect URI
        ),
      );

      // Step 2: Create a Firebase credential with the obtained Apple ID credential
      final appleCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Step 3: Sign in with Firebase using the Apple credential
      await auth.signInWithCredential(appleCredential);
      // User is signed in
    } catch (e) {
      print("Apple Sign-In error: $e");
    }
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
