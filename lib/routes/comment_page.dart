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

class CommentPage extends StatefulWidget {
  CommentPage({Key? key,required this.analytics, required this.observer, required this.userInfo, required this.products}) : super(key: key);
  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _CommentPageState createState() => _CommentPageState();
}



class _CommentPageState extends State<CommentPage> {


  Widget comments(){
    List<dynamic> comList = widget.userInfo['comments'];
/*
    if(widget.userInfo['comments'].){
      return Text("No comment...");
    }*/
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,

      child: Column(

        children: comList.map((e) => Container(
          width: 370,
          color: AppColors.secondaryColor,
          child :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e,
                style: TextStyle(
                  fontSize: 16.0,
              ),),
              SizedBox(height: 7.0),
              Divider(height: 4.0,color: AppColors.textColor,),
            ],
          ),
        )).toList(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "User Comments",
          style: kAppBarTitleLabel,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 7.0),
              comments(),
            ],
          ),
        ),
      ),
    );
  }
}
