import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:selma_sign_up/utils/styles.dart';

class BookProductTile extends StatefulWidget {

  final Product product;
  final List<Product?> products;
  const BookProductTile({required this.product, required this.products, required this.analytics, required this.observer});
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<BookProductTile> createState() => _BookProductTileState();
}

class _BookProductTileState extends State<BookProductTile> {

  Future<void> deleteProduct()async{

    DocumentSnapshot result = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      List<dynamic> books = result["productsBookmarked"];
      books.remove(widget.product.productRef);
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "productsBookmarked" : books,
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: Dimen.borderRadius ,horizontal: Dimen.borderRadius),
      shadowColor: AppColors.primaryColor,
      elevation: 8,
      child: Container(
        width: 180,
        height: 360,
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
                '${widget.product.seller}  ${widget.product.productName}',
                style: kProductCardText,
              ),

              Row(
                children: [
                  TextButton(
                      onPressed: (){},
                      child: Text(
                          "See details",
                          style: TextStyle(
                            color: AppColors.purplePrimary,
                            fontSize: 11.4,
                          )
                      )),
                  Spacer(),
                  Text(
                    '${widget.product.price}TL',
                    style: kProductCardPrice,
                  )
                ],
              )

            ],
          ),

        ),
      ),
    );
  }
}

