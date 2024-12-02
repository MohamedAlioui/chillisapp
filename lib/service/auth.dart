import 'package:chilisfinal/home.dart';
import 'package:chilisfinal/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_screen.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print("User canceled the sign-in");
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await auth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(userDetails.uid).get();

        if (userDoc.exists) {
          print("User already exists: ${userDetails.email}");
        } else {
          print("Creating new user: ${userDetails.email}");
          Map<String, dynamic> userInfoMap = {
            "email": userDetails.email,
            "name": userDetails.displayName,
            "imgUrl": userDetails.photoURL,
            "id": userDetails.uid,
          };
          await DatabaseMethods().addUser(userDetails.uid, userInfoMap);
        }

        String panierId = await _createPanier(userDetails.uid);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userEmail: userDetails.email ?? '',
              userName: userDetails.displayName ?? 'No Name',
              userPhotoUrl: userDetails.photoURL ?? '',
              userId: userDetails.uid,
              panierId: panierId,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Error: $error",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  Future<String> _createPanier(String userId) async {
    try {
      final panierRef = await _firestore.collection('paniers').add({
        'clientId': userId,
        'items': [],
        'total': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      String panierId = panierRef.id;
      await _firestore.collection('Users').doc(userId).update({
        'panierId': panierId,
      });
      print("Cart created successfully for the user.");
      return panierId;
    } catch (e) {
      print("Error creating cart: $e");
      return '';
    }
  }
}
