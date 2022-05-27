// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:iot_l6/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {

  final String title = 'Registration';

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();

  bool _success;
  String _userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _secondNameController,
                    decoration: const InputDecoration(labelText: 'Second Name'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your second name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: SignInButtonBuilder(
                      icon: Icons.person_add,
                      backgroundColor: Colors.blueGrey,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await _register();
                        }
                      },
                      text: 'Sign Up',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(_success == null
                        ? ''
                        : (_success
                        ? 'Please verify email before logging in'
                        : 'Registration failed')),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _secondNameController.dispose();

    super.dispose();
  }


  Future<void> _register() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,

      )).user;

      if (user!= null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          _success = true;
          _userEmail = user.email;
          UserModel.updateCurrentUser(UserModel(
              email: user.email, uid: user.uid, firstName: _firstNameController.text, secondName: _secondNameController.text));
        });
      }else {
        _success = false;
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register.\n $e'),
        ),
      );
    }



  }
}
