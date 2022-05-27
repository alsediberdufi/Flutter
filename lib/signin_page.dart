// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:iot_l6/HomeScreen.dart';
import 'package:iot_l6/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Page"),
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            _EmailPasswordForm(),
          ],
        );
      }),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign in.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter email';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter Password';
                    return null;
                  },
                  obscureText: true,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  alignment: Alignment.center,
                  child: SignInButton(
                    Buttons.Email,
                    text: 'Sign In',
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await _signInWithEmailAndPassword();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomeScreen([], [])));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {

      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (!user.emailVerified) throw Exception('Verify your Email!');
      var thisUser = await UserModel.getCurrentUser(user.uid);

    } catch (e) {
      if(_auth.currentUser!=null) await _auth.signOut();
      String errMessage = e.toString();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Email & Password\n$errMessage'),
        ),
      );
    }
  }
}
