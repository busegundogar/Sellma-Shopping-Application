import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/cards/bookmarks_product_tile.dart';
import 'package:selma_sign_up/cards/product_tile.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';

class WishlistPage extends StatefulWidget {
  WishlistPage({Key? key,required this.analytics, required this.observer, required this.userInfo, required this.products}) : super(key: key);
  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  List<Product> GetWishList(){
    List<Product> result = [];
    List<dynamic> wishes = widget.userInfo["productsBookmarked"];

    for(var id in wishes){
      for(var element in widget.products){
        if(id == element!.productRef)
          result.add(element);
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {

    List<Product> wishListProducts = GetWishList();
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Wishlist",
          style: kAppBarTitleLabel,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children:[
            Wrap(
              children: wishListProducts.map((Product) =>
                  BookProductTile(product: Product, analytics: widget.analytics, products: widget.products, observer: widget.observer,)).toList(),
            ),
          ],

        ),
      ),
    );
  }
}

