import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



final _fireBase = Firebase.

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredPassword = "";

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      debugPrint('Email: $_enteredEmail');
      debugPrint('Password: $_enteredPassword');
    } else {
      debugPrint('Form is not valid');
    }
  }


  void _changeIsLogin() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 100, bottom: 20, left: 20, right: 20),
              width: 200,
              child: Image.asset("assets/imgs/mess.png"),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(29),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          keyboardType: TextInputType.text, // Đúng kiểu cho mật khẩu
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Password must be longer than 6 characters";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text("Login"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: _changeIsLogin,
                          child: Text(_isLogin
                              ? "Create Account" // Sửa lỗi chính tả
                              : "I already have an account"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
