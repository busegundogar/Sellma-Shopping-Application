import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/routes/searchView.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:email_validator/email_validator.dart";
import "package:selma_sign_up/services/auth.dart";
import "package:selma_sign_up/services/auth.dart";

class Payment extends StatefulWidget {
  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;

  Payment({Key? key, required this.analytics, required this.observer, required this.userInfo, required this.products}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  final _paymentFormKey = GlobalKey<FormState>();
  String name_on_card = "";
  String card_number = "";
  String expiration_date = "";
  String cvc = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          "Payment Details",
          style: kAppBarTitleLabel,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: Dimen.sideMargin),
            child: Form(
              key: _paymentFormKey,
              child: Column(
                  children: [
                    const SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Name on Card",
                          style: kTextFieldTitle,
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,

                            validator: (value) {
                              if(value == null) {
                                return 'Name on Card field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'Name on Card field cannot be empty';
                                }
                              }
                              return null;
                            },
                            onSaved: (value){
                              if(value != null){
                                name_on_card = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Card Number",
                          style: kTextFieldTitle,
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,

                            validator: (value) {
                              if(value == null) {
                                return 'Card Number field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'Card Number field cannot be empty';
                                }
                                if(value.length != 16){
                                  return "Card Number lenght must be equal to 16";
                                }
                              }
                              return null;
                            },
                            onSaved: (value){
                              if(value != null){
                                card_number = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Expiration Date (MM/YY)",
                          style: kTextFieldTitle,
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,

                            validator: (value) {
                              if(value == null) {
                                return 'Expiration Date field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'Expiration Date field cannot be empty';
                                }
                                if(value.length != 5){
                                  return "Please enter a valid Expiration Date";
                                }
                              }
                              return null;
                            },
                            onSaved: (value){
                              if(value != null){
                                expiration_date = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("CVC",
                          style: kTextFieldTitle,
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,

                            validator: (value) {
                              if(value == null) {
                                return 'CVC field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'CVC field cannot be empty';
                                }
                                if(value.length != 3){
                                  return "Please enter a valid CVC with lenght 3";
                                }
                              }
                              return null;
                            },
                            onSaved: (value){
                              if(value != null){
                                cvc = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimen.betweenMargin),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: (
                                ) async {
                              if(_paymentFormKey.currentState!.validate()) {
                                print('Name on Card: '+name_on_card+
                                    "\nCard Number: "+card_number+
                                    "\nExpiration Date: "+expiration_date+
                                    "\nCVC: "+cvc);
                                _paymentFormKey.currentState!.save();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text('Receiving Payment')));
                              }

                              List<dynamic> bought = widget.userInfo["productsInCard"];
                              print(bought);
                              FirebaseFirestore.instance.collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid ).update(
                                  {
                                    "productsInCard" : [],
                                    "productsPurchased": FieldValue.arrayUnion(bought),
                                  });
                              for(var id in bought){
                                print(id);
                                for(var element in widget.products){
                                  print(element!.productRef);
                                  if(id == element.productRef){
                                    FirebaseFirestore.instance.collection("products").doc(id).update({
                                      "isSold": true,
                                    });
                                    var ref = element.sellerRef!.id;
                                    FirebaseFirestore.instance.collection("users").doc(ref).update({
                                      "productsOnSale": FieldValue.arrayRemove([id]),
                                      "productSold": FieldValue.arrayUnion([id]),

                                    });
                                  }
                                }
                              }

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => ProfilePage(
                                      analytics: widget.analytics,
                                      observer: widget.observer,
                                      userInfo: widget.userInfo,
                                      products: widget.products)));

                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                'Make Payment',
                                style:kLogButtonText,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}