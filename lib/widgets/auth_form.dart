import 'dart:io';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function({
    required String email,
    required String username,
    required String password,
    required bool isLogin,
    required File? image,
  }) submitForm;
  final bool isLoading;

  const AuthForm({
    required this.submitForm,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;

  String _username = '';
  String _email = '';
  String _password = '';
  File? _userImage;

  void _saveImage(File pickedImage) {
    _userImage = pickedImage;
  }

  void _submitHandler() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImage == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        AuthErrorSnackBar(text: 'Please pick an image', context: context),
      );

      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      widget.submitForm(
        email: _email.trim(),
        username: _username.trim(),
        password: _password,
        image: _userImage,
        isLogin: _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_saveImage),
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please provide a valid email address';
                    }

                    return null;
                  },
                  onSaved: (newValue) => _email = newValue!,
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 4) {
                        return 'Please provide atleast 4 characters';
                      }

                      return null;
                    },
                    onSaved: (newValue) => _username = newValue!,
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 7) {
                      return 'Password must be atleast 7 characters long.';
                    }

                    return null;
                  },
                  onSaved: (newValue) => _password = newValue!,
                ),
                const SizedBox(height: 12),
                if (widget.isLoading)
                  const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: () {
                      _submitHandler();
                    },
                    child: Text(_isLogin ? 'Login' : 'Create Account'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'Already have an account?'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
