import 'package:flutter/material.dart';
import 'package:iot_l6/HomeScreen.dart';
import './product.dart';
import './ProductPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore fb = FirebaseFirestore.instance;
class FavoritePage extends StatefulWidget {
  FavoritePage(this.shoppingCart, this.favourites) : super();

  final List<Product> shoppingCart;
  final List<Product> favourites;

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final TextEditingController textFieldController = TextEditingController();
  int _selectedPage = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Favorites'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ActionChip(
                label: Text("Save to Firebase"),
                onPressed: () {saveToFirebase();}
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: const [
                  Text(
                    "Product listed as Favorite :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.favourites.length,
                  itemBuilder: (context, index) {
                    final product = widget.favourites[index].name;
                    return Dismissible(
                        key: Key(product),
                        onDismissed: (direction) {
                          print('Remove item');
                          setState(() {
                            widget.favourites.removeAt(index);
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$product Deleted')));
                        },
                        background:Container(color: Colors.red),
                        child :  ShoppingListItem(
                          product: widget.favourites[index],
                          inCart: widget.favourites.contains(widget.favourites[index]),
                          onCartChanged: onCartChanged,
                        ));
                  }),
            )
          ],
        ),
      ),
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
        selectedItemColor: Colors.yellow,
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

  void onCartChanged(Product product, bool inCart) {
    setState(() {
      widget.favourites.remove(product);
    });
  }

  void saveToFirebase() async {
    if(_auth.currentUser != null){
      var collection = fb.collection('favorite');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      widget.favourites.forEach((element) async {await fb.collection('favorite').add(element.toMap());});
    }
  }
}





