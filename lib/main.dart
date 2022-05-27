// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart'; // Only needed if you configure the Auth Emulator below
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:iot_l6/product.dart';
import 'package:iot_l6/register_page.dart';
import 'package:iot_l6/signin_page.dart';
import 'FavoritePage.dart';
import 'ProductPage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCstJHhTXLbmSSx5mMuvRpPn-HBfSm6Feg",
      appId: "1:355108186758:android:3053810527e8140c697f07",
      messagingSenderId: "355108186758",
      projectId: "iotl6-8ffd4",
    ),
  );

  runApp(AuthExampleApp());
}

class AuthExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example App',
      //theme: ThemeData.green(),
      home: Scaffold(
        body: AuthTypeSelector([],[]),
      ),
    );
  }
}

class AuthTypeSelector extends StatefulWidget {
  AuthTypeSelector(this.shoppingCart, this.favourites) : super();

  final List<Product> shoppingCart;
  final List<Product> favourites;

  @override
  _AuthTypeSelectorState createState() => _AuthTypeSelectorState();
}

class _AuthTypeSelectorState extends State<AuthTypeSelector> {

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,

            child: SignInButtonBuilder(
              icon: Icons.person_add,
              backgroundColor: Colors.indigo,
              text: 'Registration',
              onPressed: () => _pushPage(context, RegisterPage()),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SignInButtonBuilder(
              icon: Icons.verified_user,
              backgroundColor: Colors.orange,
              text: 'Sign In',
              onPressed: () => _pushPage(context, SignInPage()),
            ),
          ),
        ],
      ),

    );
  }
}



