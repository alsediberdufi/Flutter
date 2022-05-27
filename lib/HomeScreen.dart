import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot_l6/ProductPage.dart';
import 'package:iot_l6/product.dart';
import 'package:iot_l6/user.dart';
import 'FavoritePage.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.shoppingCart, this.favourites) : super();

  final List<Product> shoppingCart;
  final List<Product> favourites;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(firstName: '', uid: '', email: '', secondName: '');

  int _selectedPage = 0;

  Future<void> NavBar(BuildContext context) async {
    if (await FirebaseAuth.instance.currentUser != null) {
      Text('wait');
    } else {
      Text('wait');
    }
  }


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: Image.asset("assets/images/logo.jpeg", fit: BoxFit.contain),
                ),
                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    )),
                Text("${loggedInUser.email}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    )),
                Text("${loggedInUser.uid}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(
                  height: 15,
                ),
                ActionChip(
                    label: Text("Lougout"),
                    onPressed: () {
                      logOut(context);
                    }),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color : Colors.blue),
            label: 'HomePage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list,color : Colors.blue),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color : Colors.blue),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
    if(index==0) {
      _navigateToHomePage(context);
    } else if(index==1) {
      _navigateToProductPage(context);
    } else {
      _navigateToFavoritePage(context);
    }
  }


  void _navigateToHomePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen(widget.shoppingCart,widget.favourites)));
  }
  void _navigateToProductPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProductPage(widget.shoppingCart,widget.favourites)));
  }
  void _navigateToFavoritePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FavoritePage(widget.shoppingCart,widget.favourites)));
  }
}

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthTypeSelector([],[])));
  }
