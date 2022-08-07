import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './firebase_options.dart';

import 'package:chat_app/screens/auth_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Chat',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            home: const AuthScreen(),
          );
        });
  }
}
