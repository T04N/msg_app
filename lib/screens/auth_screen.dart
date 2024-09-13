import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../widgets/img_input.dart';

final _firebase = FirebaseAuth.instance;

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
  var _isAuthenticating = false;
  File? _selectImage;

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || (!_isLogin && _selectImage == null)) {
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
    } else {
      debugPrint('Form is not valid');
    }

    if (_isLogin) {
    } else {
      try {
        setState(() {
          _isAuthenticating = true;
        });
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storeRef = FirebaseStorage.instance
            .ref()
            .child("user_imgs")
            .child('${userCredentials.user!.uid}.jpg');

        await storeRef.putFile(_selectImage!);
        final imgeUrl = await storeRef.getDownloadURL();
       
        FirebaseFirestore.instance.collection("user").doc(userCredentials.user!.uid).set({
          'username' : 'to be done' ,
          'email' : _enteredEmail,
          'img_url' : imgeUrl,
        });
        
        
      } on FirebaseAuthException catch (error) {
        debugPrint('FirebaseAuthException occurred: ${error.code}');
        if (error.code == "email-already-in-use") {
          //...
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authenticattion failt')));
        setState(() {
          _isAuthenticating = false;
        });
      }
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
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (File pickedImage) {
                              _selectImage = pickedImage;
                            },
                          ),
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
                          keyboardType: TextInputType.text,
                          // Đúng kiểu cho mật khẩu
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
                        if (_isAuthenticating)
                          CircularProgressIndicator(),

                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? "Login" : "Sign Up"),
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
