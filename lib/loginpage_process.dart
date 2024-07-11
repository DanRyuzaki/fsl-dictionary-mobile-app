import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsldictionary/homepage_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      // Add other required scopes
    ],
  );

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/defaultscreen_background_0.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _user != null
            ? HomePage(
                useremail: _user?.email ?? '',
                userdisplayphoto: _user?.photoURL ?? '',
                userdisplayname: _user?.displayName ?? '',
                wordListPageState: 0)
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      color: Colors.white,
                      size: 128.0,
                    ),
                    const Text(
                      "DICTIONARY",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "FSL 3D APP",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 21.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 44.0),
                    SignInButton(
                      Buttons.google,
                      text: "Authenticate with Google",
                      onPressed: _signInWithGoogle,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Sign-in failed: $e');
    }
  }
}
