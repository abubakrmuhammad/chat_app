import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = false;

  String _username = '';
  String _email = '';
  String _password = '';

  void _submitHandler() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                ElevatedButton(
                  onPressed: () {},
                  child: Text(_isLogin ? 'Login' : 'Create Account'),
                ),
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
