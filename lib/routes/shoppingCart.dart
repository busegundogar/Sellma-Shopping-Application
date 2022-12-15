import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:selma_sign_up/cards/cart_product_tile.dart';
import 'package:selma_sign_up/cards/product_tile.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/payment.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/routes/searchView.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:email_validator/email_validator.dart";
import "package:selma_sign_up/services/auth.dart";
import "package:selma_sign_up/services/auth.dart";

import '../main.dart';
import 'feedView.dart';

class ShoppingCart extends StatefulWidget {

  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  ShoppingCart({Key? key, required this.analytics, required this.observer, required this.userInfo, required this.products}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  int _selectedIndex = 2;
  List<Product?> Products = [];
  List<Product?> myProducts = [];

  void _onItemTapped(int index) async {
    DocumentSnapshot result = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0)
    {
      FirebaseFirestore.instance.collection("products").get().then((
          querySnapshot) async {
        querySnapshot.docs.forEach((result) {
          Map<String, dynamic> proData = result.data();
          Product pro = Product.func(
            proData['productName'],
            proData['brand'],
            proData['price'],
            proData['seller'],
            proData['category'],
            proData['description'],
            proData['discount'],
            proData['isSold'],
            proData['color'],
            proData['size'],
            proData['sellerRef'],
            result.id,
            double.parse(proData["rateSum"].toString()),
            double.parse(proData["raterCount"].toString()),
            proData['images'],
            proData['comment'],
          );
          Products.add(pro);
        });
        for (int i = 0; i < widget.products.length; i++)
        {
          myProducts.add(widget.products[i]!);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FeedView(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  products: Products,
                ),
          ),
        );
      });
    }
    else if (index == 1)
    {
      FirebaseFirestore.instance.collection("products").get().then((
          querySnapshot) async {
        querySnapshot.docs.forEach((result) {
          Map<String, dynamic> proData = result.data();
          Product pro = Product.func(
            proData['productName'],
            proData['brand'],
            proData['price'],
            proData['seller'],
            proData['category'],
            proData['description'],
            proData['discount'],
            proData['isSold'],
            proData['color'],
            proData['size'],
            proData['sellerRef'],
            result.id,
            double.parse(proData["rateSum"].toString()),
            double.parse(proData["raterCount"].toString()),
            proData['images'],
            proData['comment'],
          );
          Products.add(pro);
        });
        print(Products);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchView(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  products: Products,
                  userInfo: result
                ),
          ),
        );
      });
    }
    else if (index == 2)
    {
      DocumentSnapshot result = await FirebaseFirestore.instance.collection(
          'users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      FirebaseFirestore.instance.collection("products").get().then((
          querySnapshot) async {
        querySnapshot.docs.forEach((result) {
          Map<String, dynamic> proData = result.data();
          Product pro = Product.func(
            proData['productName'],
            proData['brand'],
            proData['price'],
            proData['seller'],
            proData['category'],
            proData['description'],
            proData['discount'],
            proData['isSold'],
            proData['color'],
            proData['size'],
            proData['sellerRef'],
            result.id,
            double.parse(proData["rateSum"].toString()),
            double.parse(proData["raterCount"].toString()),
            proData['images'],
            proData['comment'],
          );
          Products.add(pro);
        });
        print(Products);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ShoppingCart(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  userInfo: result,
                  products: Products,
                ),
          ),
        );
      });
    }
    else if (index == 3) {
      DocumentSnapshot result = await FirebaseFirestore.instance.collection(
          'users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      FirebaseFirestore.instance.collection("products").get().then((
          querySnapshot) async {
        querySnapshot.docs.forEach((result) {
          Map<String, dynamic> proData = result.data();
          Product pro = Product.func(
            proData['productName'],
            proData['brand'],
            proData['price'],
            proData['seller'],
            proData['category'],
            proData['description'],
            proData['discount'],
            proData['isSold'],
            proData['color'],
            proData['size'],
            proData['sellerRef'],
            result.id,
            double.parse(proData["rateSum"].toString()),
            double.parse(proData["raterCount"].toString()),
            proData['images'],
            proData['comment'],
          );
          Products.add(pro);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfilePage(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  userInfo: result,
                  products: Products,
                ),
          ),
        );
      });
    }
  }


  List<Product> Cart(){
    List<Product> aa = [];
    List<dynamic> currentCart = widget.userInfo["productsInCard"];
    for(var id in currentCart){
      for(var element in widget.products){
        if(id == element!.productRef){
          aa.add(element);
        }
      }
    }
    return aa;
  }


  @override
  Widget build(BuildContext context) {

    List<Product> userCart = Cart();

    print(userCart);

    double calculatePrice(){
      double sum = 0;
      for(var element in userCart){
        if(element.discount == 0){
          sum += element.price!;
        } else{
          sum += element.price! - ((element.price! * element.discount!) / 100);
        }

      }
      print(sum);
      return sum;
    }

    double sumTotal = calculatePrice();

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SizedBox(
        width: 170,
        height: 50,
        child: FloatingActionButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
          backgroundColor: AppColors.purplePrimary,
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  userInfo : widget.userInfo,
                  products: widget.products,
                ),));
          },
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 50,
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: Center(
                  child: Text(
                    "Your total is $sumTotal TL ",
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.arrow_forward_ios),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Shopping Cart",
          style: kAppBarTitleLabel,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [Wrap(
          children: userCart.map((Product) =>
              CartProductTile(product: Product, products: widget.products, analytics: widget.analytics, observer: widget.observer,)).toList(),
        ),]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor,
        iconSize: 30.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Special Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'My Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 16.0,
        unselectedFontSize: 14.0,
        selectedItemColor: AppColors.purplePrimary,
        unselectedItemColor: AppColors.borderColor,
        onTap: _onItemTapped,

      ),
    );
  }
}
