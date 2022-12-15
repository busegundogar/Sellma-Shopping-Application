import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/cards/product_tile.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/routes/shoppingCart.dart';
import 'package:selma_sign_up/services/firebase_data.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';

import '../main.dart';
import 'feedView.dart';

class SearchView extends StatefulWidget {
  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  SearchView({Key? key, required this.analytics, required this.observer, required this.products, required this.userInfo}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  TextEditingController editingController = TextEditingController();

  List<Product?> myProducts = [];
  List<Product?> Products = [];
  List<Product?> items = [];

  @override
  void initState() {
    myProducts = notSold();
    items.addAll(myProducts);
    super.initState();
  }

  int _selectedIndex = 1;

  Future<void> _onItemTapped(int index) async {
    DocumentSnapshot result = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
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
    else if (index == 1) {
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
        if (myProducts.length != widget.products.length) {
          for (int i = 0; i < widget.products.length; i++) {
            myProducts.add(widget.products[i]!);
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchView(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  products: Products,
                  userInfo:result
                ),
          ),
        );
      });
    }
    else if (index == 2) {
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

  String current_sort = "Alphabetical";
  static const String alphabetical = "Alphabetical";
  static const String low_to_high = "Low to High Price";
  static const String high_to_low = "High to Low Price";
  static const String clothing = "Clothing";
  static const String accessories = "Accessories";
  static const String handmade = "Handmade";
  static const List<String> sorts = <String>[
    alphabetical,
    low_to_high,
    high_to_low,
    clothing,
    accessories,
    handmade,
  ];
  List<Product?> myFilteredProducts = [];
  List<Product?> myAllProducts = [];


  void choiceAction(String choice){
    setState(() {
      current_sort = choice;

/*
      if(myAllProducts== []){
        myAllProducts = myProducts;
      }
      else{
        myProducts = myAllProducts;
      }*/

      if (choice == "Alphabetical" || choice == "Low to High Price" || choice == "High to Low Price")
        if (choice == "Alphabetical")
          myProducts.sort((a,b) => a!.productName!.compareTo(b!.productName!));
      if (choice == "Low to High Price")
        myProducts.sort((a,b) => a!.price!.compareTo(b!.price!));
      if (choice == "High to Low Price")
        myProducts.sort((a,b) => b!.price!.compareTo(a!.price!));


      if (choice == "Clothing"){
        for(var i=0; i<myProducts.length; i++){
          if(myProducts[i]!.category == "Clothing") {
            myFilteredProducts.add(myProducts[i]);
          }
        }
        myProducts = myFilteredProducts;
        print(myProducts);
      }
      if (choice == "Accessories"){
        for(var i=0; i<myProducts.length; i++){
          if(myProducts[i]!.category == "Accessories")
            myFilteredProducts.add(myProducts[i]);
        }
        myProducts = myFilteredProducts;
      }
      if (choice == "Handmade"){
        for(var i=0; i<myProducts.length; i++){
          if(myProducts[i]!.category == "Handmade")
            myFilteredProducts.add(myProducts[i]);
        }
        myProducts = myFilteredProducts;
      }
    });;

    print(current_sort);

  }



  void filterSearchResults(String searchWord) {
    myProducts.addAll(items);
    List<Product?> dummySearchList = [];
    dummySearchList = items;
    if (searchWord.isNotEmpty) {
      List<Product> dummyListData = [];
      dummySearchList.forEach((element) {
        if ((element!.productName!).toLowerCase().contains(
            (searchWord).toLowerCase()) ||
            (element.seller)!.toLowerCase().contains(
                (searchWord).toLowerCase()) ||
            (element.description)!.toLowerCase().contains(
                (searchWord).toLowerCase())) {
          dummyListData.add(element);
        }
      });
      setState(() {
        myProducts.clear();
        myProducts.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        myProducts.clear();
        myProducts.addAll(items);
      });
    }
  }

  List<Product?> notSold(){
    List<Product?> aa = [];
    for(var element in widget.products){
      if(element!.isSold == false){
        aa.add(element);
      }
    }
    return aa;
  }

    @override
    Widget build(BuildContext context) {
      //myProducts = notSold();

      return Scaffold(
        backgroundColor: AppColors.secondaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            "Products",
            style: kAppBarTitleLabel,
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return sorts.map((String sort){
                  return PopupMenuItem<String>(
                    value: sort,
                    child: Text(sort),
                  );
                }).toList();
              },
            ),
          ],

        ),
        body: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search for a word",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25.0)))),
                    ),
                  ),
                  Wrap(
                    children: myProducts.map((Product) =>
                        ProductTile(product: Product!,
                          products: widget.products,
                          observer: MyApp.observer,
                          analytics: MyApp.analytics,
                          userInfo: widget.userInfo,
                        )).toList(),
                  )

                ]
            )
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
