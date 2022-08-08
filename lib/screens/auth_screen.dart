import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  void _submitForm({
    required String email,
    required String username,
    required String password,
    required bool isLogin,
    required File? image,
  }) async {
    final UserCredential userCredential;

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final newUser = userCredential.user;

        if (newUser != null && image != null) {
          final imageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${newUser.uid}.jpg');

          await imageRef.putFile(image);

          final imageUrl = await imageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(newUser.uid)
              .set({
            'username': username,
            'email': email,
            'imageUrl': imageUrl,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occured';

      // message = e.message ?? message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Email provided is invalid';
          break;
        case 'weak-password':
          message = 'Password provided is too weak';
          break;
        case 'email-already-in-use':
          message = 'A user with that email already exists';
          break;
        case 'user-not-found':
          message = 'No user with that email found';
          break;
        case 'wrong-password':
          message = 'The password provided is incorrect';
          break;
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        AuthErrorSnackBar(text: message, context: context),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        AuthErrorSnackBar(text: 'Something went wrong', context: context),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: AuthForm(
            submitForm: _submitForm,
            isLoading: _isLoading,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class AuthErrorSnackBar extends SnackBar {
  AuthErrorSnackBar({
    Key? key,
    required this.text,
    required this.context,
  }) : super(
          content: Text(text, textAlign: TextAlign.center),
          backgroundColor: Theme.of(context).errorColor,
          key: key,
        );

  final String text;
  final BuildContext context;
}
