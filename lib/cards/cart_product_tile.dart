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

class CartProductTile extends StatefulWidget {

  final Product product;
  final List<Product?> products;
  const CartProductTile({required this.product, required this.products, required this.analytics, required this.observer});
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  Widget pricing(){
    //UPDATE THE DISCOUNT AMOUNT!!!!
    if (widget.product.discount == 0)
      return Text(
        "${widget.product.price.toString()} TL",
        style: TextStyle(
          color: AppColors.purplePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      );
    else {
      double priceAfterDiscount = widget.product.price! * ((100 - widget.product.discount!) / 100);
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

  Future<void> deleteProduct()async{

    DocumentSnapshot result = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      List<dynamic> cart = result["productsInCard"];
      cart.remove(widget.product.productRef);
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "productsInCard" : cart,
      });
    });



  }

  @override
  Widget build(BuildContext context) {

    Future<void> _goToDetails()async {
      DocumentSnapshot result = await FirebaseFirestore.instance.collection(
          'users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          ProductPage(analytics: widget.analytics, observer: widget.observer, product: widget.product, userInfo: result, products: widget.products,)));
    }



    return Card(
      margin: EdgeInsets.symmetric(vertical: Dimen.borderRadius ,horizontal: Dimen.borderRadius),
      shadowColor: AppColors.primaryColor,
      elevation: 8,
      child: Container(
        width: 180,
        height: 380,
        child: Padding(
          padding: EdgeInsets.all(Dimen.borderRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: deleteProduct,
                      icon: const Icon(Icons.delete))
                ],
              ),

              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: 100,
                    height: 200,
                    child: Image(image: NetworkImage('${widget.product.images![0]}')),

                  )
              ),

              Text(
                '${widget.product.productName}',
                style: TextStyle(fontSize: 15.0,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w800),
              ),
              Text('${widget.product.seller}',
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
                      )),
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

