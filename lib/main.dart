import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User currentUser;
  String name = "";
  String email = "";
  String url = "";

  Future<void> googleSingIn() async {
    try {
      UserCredential userCredential;

      if(kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount account = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
        await account.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('GOOGLE SIGNIN SUCCESS!! user id : ${userCredential.user.uid}')));

    } catch (exception) {
      print(exception);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('GOOGLE SIGNIN FAIL : $exception')));
    }
  }

  Future<void> faceBookSingIn() async {
    try {
      User user;
      if(kIsWeb) {
        var facebookProvider = FacebookAuthProvider();
        user = (await FirebaseAuth.instance.signInWithPopup(facebookProvider)).user;
      } else {
        final AccessToken result = await FacebookAuth.instance.login();
        final facebookAuthCredential = FacebookAuthProvider.credential(result.token);
        user = (await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)).user;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('FACEBOOK SIGNIN SUCCESS!! user id : ${user.uid}')));

    }catch(exception) {
      print(exception);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('FACEBOOK SIGNIN FAIL : $exception')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        googleSingIn();
                      },
                      child: Text('google logIn')),
                  TextButton(
                      onPressed: () {
                        faceBookSingIn();
                      },
                      child: Text('facebook logIn'))
        ])));
  }
}
