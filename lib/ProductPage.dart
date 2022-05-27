import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_l6/HomeScreen.dart';
import './product.dart';
import './FavoritePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore fb = FirebaseFirestore.instance;

class ProductPage extends StatefulWidget {
  ProductPage(this.shoppingCart, this.favourites) : super();

  final List<Product> shoppingCart;
  final List<Product> favourites;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController searchBarController = TextEditingController();

  int _selectedPage = 1;
  String query = "";

  @override
  Widget build(BuildContext context) {

    List<Product> productsGen = search(query);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:Text("My Shopping List"),
        actions: [
          IconButton(
            onPressed: (){
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: const [
                  Icon(Icons.shopping_cart,size: 30),

                  Text(
                    "Products you have to buy",
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

                  itemCount: productsGen.length,
                  itemBuilder: (context, index) {

                    final product = productsGen[index].name;
                    if(query=="") {
                      return Dismissible(
                        key: Key(product),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            print("Add to favorite");
                            setState(() {
                              widget.favourites.add(widget.shoppingCart[index]);
                              widget.shoppingCart.removeAt(index);
                               Colors.green;
                            });
                          } else {
                            print('Remove item');
                            setState(() {
                              widget.shoppingCart.removeAt(index);
                              Colors.red;
                            });
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$product added to favorites!')));
                        },
                        background:Container(color: Colors.amber),
                        child :  ShoppingListItem(
                          product: productsGen[index],
                          inCart: widget.shoppingCart.contains(productsGen[index]),
                          onCartChanged: onCartChanged,
                        ));
                    } else {
                      return Card(
                        child: ShoppingListItem(
                          product: productsGen[index],
                          inCart: widget.shoppingCart.contains(productsGen[index]),
                          onCartChanged: onCartChanged,
                        )
                    );
                    }
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayDialog(context),
        child: Icon(Icons.add),
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),// This trailing comma makes auto-formatting nicer for build methods.
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

  Future displayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Add a new product to your list",
              textAlign: TextAlign.center,
            ),
            content: Column(
              children: [
                Text('Name :'),
                TextField(
                  controller: nameController,
                ),
                Text('Price :'),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text('Quantity :'),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // print(textFieldController.text);
                  if (nameController.text.trim() != "" && priceController.text.trim() != "" && quantityController.text.trim() != "" )
                    setState(() {
                      widget.shoppingCart.add(Product(name: nameController.text,price: int.parse(priceController.text),quantity: int.parse(quantityController.text)));
                    });

                  nameController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("save"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        });
  }

  void onCartChanged(Product product, bool inCart) {
    setState(() {
      widget.shoppingCart.remove(product);
    });
  }

  List<Product> search(String query){
    return widget.shoppingCart.where((item){
      final itemName = item.name.toLowerCase();
      //final input = query.toLowerCase();
      return itemName.contains(query);
    }).toList();
  }
}

class CustomSearchDelegate  extends SearchDelegate{
  List<String> searchTerms = [
    "car",
    "car1",
    "toy",
  ];



  @override
  List<Widget> buildActions(BuildContext context){
    return[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          query= '';
        },
      ),
    ];
  }

  @override
  Widget  buildLeading(BuildContext context){
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context){
    List<String> matchQuery = [];
    for(var search in searchTerms){
      if(search.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(search);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index){
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var search in searchTerms) {
      if (search.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(search);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}

