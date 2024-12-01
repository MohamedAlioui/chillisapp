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

  // Current user
  Future<User?> getCurrentUser() async {
    return await auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print("User canceled the sign-in");
        return; // Exit if the user cancels the sign-in
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // Sign in with Firebase using the Google credentials
      UserCredential result = await auth.signInWithCredential(credential);

      User? userDetails = result.user;

      if (userDetails != null) {
        // Check if user exists in Firestore, otherwise add them
        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email,
          "name": userDetails.displayName,
          "imgUrl": userDetails.photoURL,
          "id": userDetails.uid,
        };

        // Add the user data to Firestore
        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);

        // Create a cart (panier) for the user
        await _createPanier(userDetails.uid);

        // Pass user data to the HomeScreen and navigate
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userEmail: userDetails.email ?? '',
              userName: userDetails.displayName ?? 'No Name',
              userPhotoUrl: userDetails.photoURL ?? '',
              userId: userDetails.uid,
              panierId: '',
            ),
          ),
              (Route<dynamic> route) => false, // Remove all previous routes
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

  // Create a cart (panier) for the user after Google sign-in
  Future<void> _createPanier(String userId) async {
    try {
      // Create a new cart in Firestore under the 'paniers' collection
      await _firestore.collection('paniers').doc(userId).set({

        'clientId': userId,
        'items': [], // Initialize with an empty list of items
        'total': 0.0, // Initialize with a total of 0
        'createdAt': FieldValue.serverTimestamp(),
      });
      final panierRef = await _firestore.collection('paniers').add({
        'clientId': userId,  // Store user ID to associate the cart with the user
        'items': [],          // Initialize with an empty list of items
        'total': 0.0,         // Initialize total cost as 0
        'createdAt': FieldValue.serverTimestamp(),  // Store timestamp of creation
      });
      String panierId = panierRef.id;
      await _firestore.collection('Users').doc(userId).update({
        'panierId': panierId,  // Store the panierId to easily reference it later
      });
      // You can also link this cart ID back to the user document if needed
      // await _firestore.collection('Users').doc(userId).update({
      //   'panierId': userId, // This is just an example, you can link the panier as needed
      // });

      print("Cart created successfully for the user.");
    } catch (e) {
      print("Error creating cart: $e");
    }
  }
}
