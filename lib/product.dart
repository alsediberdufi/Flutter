import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final int price;
  final int quantity;


  const Product({required this.name,required this.price, required this.quantity,});

  factory Product.fromMap(map){
    return new Product(
      name: map ['name'],
      price: map ['price'],
      quantity: map ['quantity'],

    );
  }

  Map<String,dynamic> toMap(){
    return{
      'name' : name,
      'price' : price,
      'quantity' : quantity,
    };
  }
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  final TextEditingController textFieldController = TextEditingController();
  final Product product;
  final inCart;
  final CartChangedCallback onCartChanged;

  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      leading: CircleAvatar(
        backgroundColor: Colors.amber,
        child: Text(product.name[0]),
      ),
      onTap: () {
        displayProduct(context);
      },
    );
  }

  Future displayProduct(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            content: Column(
              children: [
                Text('Quantity :'+product.quantity.toString()),
                Text('Price :'+product.price.toString()),
              ],
            ),
            actions: [
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
}
