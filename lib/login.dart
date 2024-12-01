import 'package:chilisfinal/home.dart';
import 'package:chilisfinal/screens/home_screen.dart';
import 'package:chilisfinal/service/auth.dart';
import 'package:chilisfinal/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgot_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  // Function to login the user and navigate to HomeScreen
  userLogin(BuildContext context, String email, String password) async {
    try {
      // Attempt to sign in the user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the complete user data (email, name, photoUrl, etc.)
      User? user = userCredential.user;
      String userEmail = user?.email ?? 'No Email';
      String userName = user?.displayName ?? 'Guest';
      String? userPhotoUrl = user?.photoURL;
      String? userId = user?.uid ?? '';
      // Pass the complete user data to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userEmail: userEmail,
            userName: userName,
            userPhotoUrl: userPhotoUrl ?? '',
            userId: userId,
            panierId: '',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = "No User Found for that Email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong Password Provided";
      } else {
        message = e.message ?? 'An error occurred';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(message, style: TextStyle(fontSize: 18.0)),
      ));
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    mailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/car.PNG", // Ensure this path is correct
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(30)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter E-mail';
                          }
                          return null;
                        },
                        controller: mailcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf), fontSize: 18.0)),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(30)),
                      child: TextFormField(
                        controller: passwordcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf), fontSize: 18.0)),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = mailcontroller.text;
                            password = passwordcontroller.text;
                          });
                          userLogin(context, email, password);
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: Color(0xFF273671),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500),
                              ))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()));
                      },
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              color: Color(0xFF8c8e98),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "or LogIn with",
                      style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AuthMethods().signInWithGoogle(context);
                          },
                          child: Image.asset(
                            "images/google.png", // Ensure this path is correct
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style: TextStyle(
                                color: Color(0xFF8c8e98),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUp()));
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Color(0xFF273671),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
