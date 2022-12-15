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

class OrderPage extends StatefulWidget {
  OrderPage({Key? key,required this.analytics, required this.observer, required this.userInfo, required this.products}) : super(key: key);
  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  List<Product> GetOrders(){
    List<Product> result = [];
    List<dynamic> orders = widget.userInfo["productsPurchased"];

    for(var id in orders){
      for(var element in widget.products){
        if(id == element!.productRef)
          result.add(element);
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {

    List<Product> orderedProducts = GetOrders();
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Orders",
          style: kAppBarTitleLabel,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children:[
            Wrap(
              children: orderedProducts.map((Product) =>
                  ProductTile(product: Product, products: widget.products, observer: widget.observer, analytics: widget.analytics,userInfo: widget.userInfo,)).toList(),
            ),
          ],

        ),
      ),
    );
  }
}