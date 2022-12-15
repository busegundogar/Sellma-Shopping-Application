import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/product_page.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:selma_sign_up/utils/styles.dart';

import '../main.dart';

class ProductTile extends StatelessWidget {

  final Product product;
  final List<Product?> products;
  DocumentSnapshot<Object?> userInfo;
  ProductTile({required this.product, required this.products, required this.analytics, required this.observer, required this.userInfo});
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Widget pricing(){
    //UPDATE THE DISCOUNT AMOUNT!!!!
    if (product.discount == 0)
      return Text(
        "${product.price.toString()} TL",
        style: TextStyle(
          color: AppColors.purplePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      );
    else {
      double priceAfterDiscount = product.price! * ((100 - product.discount!) / 100);
      return Text(
        "${priceAfterDiscount.toStringAsFixed(2)} TL",
        style: TextStyle(
          color: AppColors.purplePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {

    Future<void> _goToDetails()async {
      DocumentSnapshot result = await FirebaseFirestore.instance.collection(
          'users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          ProductPage(analytics: analytics, observer: observer, product: product, userInfo: result, products: products,)));
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: Dimen.borderRadius ,horizontal: Dimen.borderRadius),
      shadowColor: AppColors.primaryColor,
      elevation: 8,
      child: Container(
        width: 180,
        height: 330,  //320'den 330'a değiştirdim
        child: Padding(
          padding: EdgeInsets.all(Dimen.borderRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: 100,
                    height: 200,
                    child: Image(image: NetworkImage('${product.images![0]}')),

                  )
              ),

              Text(
                '${product.productName}',
                style: TextStyle(fontSize: 15.0,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w800),
              ),
              Text('${product.seller}',
                style: kProductCardText,
              ),
              Divider(thickness: 1.0),
              Row(
                children: [
                  TextButton(
                      onPressed: _goToDetails,
                      child: Text(
                          "See details",
                          style: TextStyle(
                            color: AppColors.purplePrimary,
                            fontSize: 11.4,
                          )
                      )
                  ),
                  Spacer(),

                  pricing(),
                ],
              )

            ],
          ),

        ),
      ),
    );
  }
}
