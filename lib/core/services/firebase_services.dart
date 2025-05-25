import 'dart:convert'; // For base64Encode
import 'dart:math'; // For random number generation (nonce)
import 'package:crypto/crypto.dart'; // For sha256 (add crypto package to pubspec.yaml)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Import for Firebase.initializeApp
import 'package:flutter/foundation.dart' show kIsWeb; // For platform checking
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseServices extends GetxService {
  // Make auth private and provide a getter if needed, or keep it public if direct access is preferred.
  late FirebaseAuth _auth;
  FirebaseAuth get auth => _auth; // Public getter

  // Getter to easily access the current user
  User? get currentUser => _auth.currentUser;

  // Ensures Firebase is initialized before this service is fully ready.
  // This is crucial.
  Future<FirebaseServices> init() async {
    // Ensure Firebase core is initialized. This should ideally be in your main.dart
    // but putting a check here can be a safeguard.
    if (Firebase.apps.isEmpty) {
      // Replace with your actual FirebaseOptions if not using flutterfire_cli
      // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await Firebase.initializeApp(); // Assuming flutterfire_cli setup
      printInfo(info: 'Firebase Initialized in FirebaseServices');
    } else {
      printInfo(info: 'Firebase already initialized');
    }

    _auth = FirebaseAuth.instance;

    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        printInfo(info: 'User is currently signed out!');
      } else {
        printInfo(
          info: 'User is signed in! UID: ${user.uid}, Email: ${user.email}',
        );
        // You might want to navigate or update UI based on this.
        // e.g., Get.find<UserController>().setUser(user);
      }
    });
    return this;
  }

  @override
  void onInit() {
    super.onInit();
    // No need to `await` init() here as GetxService onInit is synchronous.
    // The init() method is designed to be called explicitly, often from main.dart
    // or a GetX binding that ensures it completes before the app needs it.
    // If you must initialize it here, consider making onInit async (though less common for GetxService)
    // or using a flag to indicate initialization status.
    // For now, assuming `init()` is called externally:
    // init(); // Or await init(); if onInit becomes async
  }

  /// Generates a cryptographically secure random nonce.
  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Hashes the nonce.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential?> signInGoogle() async {
    try {
      // For web platform:
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final UserCredential userCredential = await _auth.signInWithPopup(
          googleProvider,
        );
        printInfo(
          info:
              'Google Sign-In (Web) User: ${userCredential.user?.displayName}',
        );
        return userCredential;
      } else {
        // For mobile platforms (Android/iOS) using google_sign_in
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          // User cancelled the sign-in
          printInfo(info: 'Google Sign-In cancelled by user.');
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        printInfo(
          info:
              'Google Sign-In (Mobile) User: ${userCredential.user?.displayName}',
        );
        return userCredential;
      }
    } catch (e, s) {
      printError(info: 'Google Sign-In error: $e\nStack: $s');
      Get.snackbar(
        "Google Sign-In Failed",
        "An error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Future<UserCredential?> signInApple() async {
  //   // Nonce for replay protection
  //   final rawNonce = _generateNonce();
  //   final hashedNonce = _sha256ofString(rawNonce);

  //   try {
  //     // This part uses the 'sign_in_with_apple' package
  //     final appleIdCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: hashedNonce, // Pass the hashed nonce
  //       webAuthenticationOptions:
  //           kIsWeb // Conditionally provide web options
  //               ? WebAuthenticationOptions(
  //                 // Your Services ID, e.g., com.example.myservice
  //                 clientId:
  //                     'com.decodersfamily.jourapothole', // THIS IS YOUR APPLE SERVICES ID
  //                 // Your Redirect URI, make sure it's registered in Apple Developer Console
  //                 // and is HTTPS for production.
  //                 redirectUri:
  //                 // For Firebase Hosting, it's usually:
  //                 // Uri.parse('https://your-project-id.firebaseapp.com/__/auth/handler'),
  //                 // Or your custom domain.
  //                 Uri.parse(
  //                   'https://www.joinventureai.com/callback',
  //                 ), // YOUR CONFIGURED REDIRECT URI
  //               )
  //               : null,
  //     );

  //     // Create an OAuthCredential for Firebase
  //     final oauthCredential = OAuthProvider('apple.com').credential(
  //       idToken: appleIdCredential.identityToken,
  //       rawNonce: rawNonce, // Pass the raw nonce
  //       accessToken:
  //           appleIdCredential
  //               .authorizationCode, // Usually needed, especially if you refresh tokens server-side
  //     );

  //     // Sign in to Firebase with the Apple credential
  //     final UserCredential userCredential = await _auth.signInWithCredential(
  //       oauthCredential,
  //     );
  //     printInfo(
  //       info: 'Apple Sign-In User: ${userCredential.user?.displayName}',
  //     );

  //     // Update user profile with name if available (Apple only provides it on the first sign-in)
  //     if (userCredential.user != null &&
  //         (appleIdCredential.givenName != null ||
  //             appleIdCredential.familyName != null)) {
  //       String? displayName =
  //           (appleIdCredential.givenName ?? "") +
  //           (appleIdCredential.givenName != null &&
  //                   appleIdCredential.familyName != null
  //               ? " "
  //               : "") +
  //           (appleIdCredential.familyName ?? "");
  //       if (displayName.trim().isNotEmpty &&
  //           userCredential.user!.displayName != displayName) {
  //         await userCredential.user!.updateDisplayName(displayName.trim());
  //         printInfo(
  //           info: 'Updated Firebase user display name from Apple: $displayName',
  //         );
  //       }
  //     }
  //     if (userCredential.user != null &&
  //         appleIdCredential.email != null &&
  //         userCredential.user!.email == null) {
  //       // Apple might provide the email only on the first sign-in.
  //       // Firebase automatically links if the email is verified by Apple and not yet in Firebase.
  //       // If the email is already in Firebase with another provider, an error might occur.
  //       // You might need to link accounts or handle `FirebaseAuthException` with code `account-exists-with-different-credential`.
  //       // For simplicity, we are not updating email here as Firebase handles it during signInWithCredential.
  //       printInfo(info: 'Apple provided email: ${appleIdCredential.email}');
  //     }

  //     return userCredential;
  //   } on SignInWithAppleAuthorizationException catch (e) {
  //     String errorMessage = "Apple Sign-In failed.";
  //     switch (e.code) {
  //       case AuthorizationErrorCode.canceled:
  //         errorMessage = "Apple Sign-In canceled by user.";
  //         break;
  //       case AuthorizationErrorCode.failed:
  //         errorMessage = "Apple Sign-In failed. Please try again.";
  //         break;
  //       case AuthorizationErrorCode.invalidResponse:
  //         errorMessage = "Apple Sign-In received an invalid response.";
  //         break;
  //       case AuthorizationErrorCode.notHandled:
  //         errorMessage = "Apple Sign-In not handled. Ensure setup is correct.";
  //         break;
  //       case AuthorizationErrorCode.unknown:
  //         errorMessage = "An unknown error occurred with Apple Sign-In.";
  //         break;
  //     }
  //     printError(
  //       info: 'Apple Sign-In Authorization error: ${e.code} - ${e.message}',
  //     );
  //     Get.snackbar(
  //       "Apple Sign-In Failed",
  //       errorMessage,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return null;
  //   } catch (e, s) {
  //     printError(info: 'Apple Sign-In general error: $e\nStack: $s');
  //     Get.snackbar(
  //       "Apple Sign-In Failed",
  //       "An error occurred: ${e.toString()}",
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return null;
  //   }
  // }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // If using Google Sign In on mobile (with google_sign_in package), you'd also call:
      // await GoogleSignIn().signOut();
      // For Apple, SignInWithApple doesn't have a separate signOut, Firebase signOut is enough.
      printInfo(info: 'User signed out successfully.');
      // Potentially navigate to login screen
      // Get.offAllNamed('/login');
    } catch (e) {
      printError(info: 'Error signing out: $e');
      Get.snackbar(
        "Sign Out Error",
        "Could not sign out: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // No need for onReady and onClose if they are empty, GetxService provides defaults.
  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
