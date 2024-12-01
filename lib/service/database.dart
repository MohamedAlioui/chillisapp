import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods{
  Future addUser(String userId, Map<String, dynamic>  userInfoMap){
    return FirebaseFirestore.instance.collection("Users").doc(userId).set(userInfoMap);
  }
}