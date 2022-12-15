import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:selma_sign_up/services/db.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:path/path.dart';

import '../main.dart';

class AddProduct extends StatefulWidget {

  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  AddProduct({Key? key, required this.analytics, required this.observer,  required this.userInfo, required this.products}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  var firebaseUser =  FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

  final _newformKey = GlobalKey<FormState>();
  AuthService auth = AuthService();
  String productName = "";
  String brand = "";
  String category = "";
  String color = "";
  String description = "";
  String size = "";
  String price = "";
  String discount = "";
  int priceInt = 0;
  int discountInt = 0;
  List<String> productImages = [];

  //Seller infosunu al, bunu da database e ekle
  //Image al, database e ekle
  //Comments ? bunu ilk başta productı eklerken 0 olarak initialize etmemiz gerekiyor mu bilmiyorum

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {

    String fileName = basename(_image!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    try {
      await firebaseStorageRef.putFile(File(_image!.path));
      print("Upload complete");

      String? imageURL;
      await firebaseStorageRef.getDownloadURL().then((fileURL){
        imageURL = fileURL;
      });

      productImages.add(imageURL!);

      setState(() {
        _image = null;
      });
    } on FirebaseException catch(e) {
      print('ERROR: ${e.code} - ${e.message}');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Add Product to Sell',
              style: kAppBarTitleLabel,
            ),
          ],
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
              key : _newformKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 25.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 250,
                                  width: 250,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: _image != null
                                          ? Image.file(File(_image!.path)) : TextButton(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                        ),
                                        onPressed: pickImage,
                                      )
                                  ),
                                )
                              ],
                            ),

                          ] ,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimen.betweenMargin),

                  OutlinedButton(

                    onPressed: () {
                      if(_image != null){
                        uploadImageToFirebase(context);
                      }
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Save Product Picture',
                        style:kLogButtonText,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.textColor,
                    ),
                  ),

                  const SizedBox(height: Dimen.betweenMargin),

                  const Divider(
                    color: AppColors.textColor,
                    thickness: 5.0,
                  ),

                  //Product Name Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Product Name",
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
                              return 'Product Name field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Product Name field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              productName = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Brand Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Brand Name",
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
                              return 'Brand Name field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Brand Name field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              brand = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Category Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Category",
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
                              return 'Category field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Category field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              category = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Color Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Color",
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
                              return 'Color field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Color field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              color = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Description Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Description",
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
                              return 'Description field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Description field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              description = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Size Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Size",
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
                              return 'Size field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Size field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              size = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Price Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Price",
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
                              return 'Price field cannot be empty';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Price field cannot be empty';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              price = value;
                              priceInt = int.parse(price);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Discount Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Discount %",
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
                              return 'Discount field cannot be empty, it can be assigned as 0';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'Discount field cannot be empty, it can be assigned as 0';
                              }
                            }
                            return null;
                          },
                          onSaved: (value){
                            if(value != null){
                              discount = value;
                              discountInt = int.parse(discount);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimen.betweenMargin),

                  //Add Product - DATABASE DIDN'T IMPLEMENTED!
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () async {
                            if(_newformKey.currentState!.validate()) {
                              print('Product Name: '+productName+
                                  "\nBrand: "+brand+
                                  "\nCategory: "+category+
                                  "\nColor: "+color+
                                  "\nDescription: "+description+
                                  "\nSize: "+size+
                                  "\nPrice: "+price+
                                  "\nDiscount: "+discount);
                              _newformKey.currentState!.save();
                              print('Product Name: '+productName+
                                  "\nBrand: "+brand+
                                  "\nCategory: "+category+
                                  "\nColor: "+color+
                                  "\nDescription: "+description+
                                  "\nSize: "+size+
                                  "\nPrice: "+price+
                                  "\nDiscount: "+discount);
                              _newformKey.currentState!.save();

                              //ADD PRODUCT TO THE DATABASE
                              await firestoreInstance.collection("products").add({
                                "brand": brand,
                                "category" : category,
                                "color": color,
                                "description": description,
                                "discount": discountInt,
                                "isSold": false,
                                "price": priceInt,
                                "productName": productName,
                                "seller":brand,
                                "size":size,
                                "comment": [],
                                "images" : productImages,
                                "rateSum": 0,
                                "raterCount": 0,
                                "sellerRef": firestoreInstance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid ),
                              }).then((value) {
                                print(value.id);
                                firestoreInstance.collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid ).update(
                                    {
                                      "productsOnSale" : FieldValue.arrayUnion([value.id]),
                                    });


                              });

                              print('${FirebaseAuth.instance.currentUser!.uid}');


                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text('Product is uploading')));

                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      analytics: widget.analytics,
                                      observer: widget.observer,
                                      userInfo: widget.userInfo,
                                      products: widget.products)));

                            }


                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'Add Product',
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
                  const SizedBox(height: Dimen.betweenMargin),
                ],
              ),
            ),
          ),
        ),

      ),

    );
  }
}