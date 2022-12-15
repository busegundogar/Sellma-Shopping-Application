import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/corporate_signup.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:selma_sign_up/utils/styles.dart';

class ProductPage extends StatefulWidget {
  DocumentSnapshot<Object?> userInfo;
  ProductPage({Key? key, required this.analytics, required this.observer, required this.product, required this.products, required this.userInfo}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final Product product;
  final List<Product?> products;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  //PARAMETERS, IMPORTANT TWO STEP NEEDED!
  // STEP 1 - Get the product info when see details clicked
  // STEP 2 - If user adds the product to their shopping cart, so get the user info!


  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  @override
  void initState(){
    super.initState();
    controller = TransformationController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Widget comments(){

    if(widget.product.comments!.isEmpty){
      return Text("No comment...");
    }
    else{
      print( widget.product.comments);

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Column(


          children: widget.product.comments!.map((e) => Container(
            width: 370,
            color: AppColors.secondaryColor,
            child :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e,),
                SizedBox(height: 7.0),
                Divider(height: 4.0,color: AppColors.textColor,),
              ],
            ),
          )).toList(),
        ),
      );
    }
  }

  bool userCheck(){

    for(var prod in widget.userInfo['productsPurchased']){
      print(prod);
      if(prod == widget.product.productRef){
        return true;
      }
    }
    return false;
  }


  Widget images(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      //Get Product Images list from firebase using the product info from step 1 and add them through loop maybe?
      //For this purpose this widget returning function should get that product info as a parameter

      child: Row(
        children: widget.product.images!.map((e) => Container(
            height: 250,
            width: 250,
            color: AppColors.secondaryColor,
            child: GestureDetector(
              onDoubleTapDown: (details) => tapDownDetails = details,
              onDoubleTap: (){
                final position = tapDownDetails!.localPosition;
                final double scale = 3;
                final x = -position.dx * (scale - 1);
                final y = -position.dy * (scale - 1);
                final zoomed = Matrix4.identity()
                  ..translate(x,y)
                  ..scale(scale);

                final value = controller.value.isIdentity()  ? zoomed: Matrix4.identity() ;
                controller.value = value;
              },
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                transformationController: controller,
                panEnabled: false,
                scaleEnabled: false,
                child: Image(image: NetworkImage(e!)),
              ),
            )

        )).toList(),



      ),
    );
  }

  Widget pricing(){
    //UPDATE THE DISCOUNT AMOUNT!!!!
    if (widget.product.discount == 0)
      return Text(
        "${widget.product.price.toString()} TL",
        style: TextStyle(
          color: AppColors.purplePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      );
    else {
      double priceAfterDiscount = widget.product.price! * ((100 - widget.product.discount!) / 100);
      return Text(
        "${widget.product.price!.toStringAsFixed(2)} TL --> ${priceAfterDiscount.toStringAsFixed(2)} TL",
        style: TextStyle(
          color: AppColors.purplePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {

    String? ref = widget.product.sellerRef.toString();
    double _rateSum = double.parse(widget.product.rateSum.toString());
    double _raterCount = double.parse(widget.product.raterCount.toString());
    double _initialRating = double.parse((_rateSum/_raterCount).toStringAsFixed(2));
    String _comment = "";
    final _formKey = GlobalKey<FormState>();

    void addToCart() {
      List<dynamic> currentCart = [];


      for (var element in widget.products) {
        if(element!.productName == widget.product.productName){
          currentCart.add(element.productRef);
        }
      }
      print(currentCart);
      setState(() {
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "productsInCard" : FieldValue.arrayUnion(currentCart),
        });
      });

      print(widget.userInfo["productsInCard"]);
    }

    void addToFavs() {
      List<dynamic> currentBookmarks = [];


      for (var element in widget.products) {
        if(element!.productName == widget.product.productName){
          currentBookmarks.add(element.productRef);
        }
      }
      print(currentBookmarks);
      setState(() {
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "productsBookmarked" : FieldValue.arrayUnion(currentBookmarks),
        });
      });

      print(widget.userInfo["productsBookmarked"]);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
            widget.product.productName!,
            style: kProMainBold
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          reverse:true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              images(),

              SizedBox(height: 10.0,),

              Row(
                children: [
                  Text(widget.product.seller!,
                    style: kProMainBold,
                  ),

                  Text("   "),
                  Text(
                      widget.product.productName!,
                      style: kProMain
                  ),

                ],
              ),

              Divider(
                height: 3.0,
                thickness: 5.0,
                color: AppColors.purplePrimary,
              ),

              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    pricing(),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: _initialRating,
                    minRating: 1,
                    itemSize: 30,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),

                    onRatingUpdate: (rating) async{

                      _raterCount++;
                      _rateSum += rating;

                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                        "rateSum" : _rateSum,
                        "raterCount" : _raterCount,
                      });

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('You rated!'),
                          content:  Text(
                              'Successfully gave $rating stars!'),
                          actions: <Widget>[
                            //
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),


              SizedBox( height: 5.0,),
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[


                      IconButton(
                        onPressed: addToFavs,
                        icon: const Icon(
                            Icons.favorite
                        ),
                      ),
                      const Text(
                        'Add to Wishlist',
                      ),
                    ],
                  ),


                  SizedBox(width: 10.0,),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      IconButton(
                        onPressed: addToCart,
                        icon: const Icon(
                            Icons.add_shopping_cart
                        ),
                      ),
                      const Text(
                        'Add to Cart',
                      ),
                    ],
                  ),
                  SizedBox(width: 10.0,),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () async {

                    String ref = widget.product.sellerRef!.id;
                    DocumentSnapshot result =  await FirebaseFirestore.instance.collection('users').doc(ref).get();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          analytics: widget.analytics,
                          observer: widget.observer,
                          userInfo : result,
                          products: widget.products,
                        ),
                      ),
                    );
                  },
                    child: Text('Click to visit seller\'s profile ->',
                      //style: kProMain,
                      style: kProProductPage,
                    ),
                  ),
                ],
              ),


              SizedBox(width: 10.0,),

              const SizedBox(height: 8.0),

              //Text("Product Rating: "+ widget.product.rating.toString()+"/5"),

              const SizedBox(height: 15.0),

              Container(
                  color: AppColors.secondaryColor,
                  width: 370,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product Description",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0
                        ),),

                        SizedBox(height: 8.0,),

                        Text("${widget.product.description}",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 15.0
                          ),),

                        SizedBox(height: 5.0,),

                        Text("Category: ${widget.product.category}",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 15.0
                          ),),

                        SizedBox(height: 5.0,),

                        Text("Color: ${widget.product.color}",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 15.0
                          ),),

                        SizedBox(height: 5.0,),

                        Text("Size: ${widget.product.size}",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 15.0
                          ),),

                      ],
                    ),
                  ),
              ),

              SizedBox(height: Dimen.betweenMargin,),

              Container(
                color: AppColors.secondaryColor,
                width: 370,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Comment ",
                        style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                        ),),

                      Form(
                        key : _formKey,
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
                          minLines: 1,
                          maxLines: 3,
                          maxLength: 70,

                          validator: (value) {
                            if(value == null) {
                              return 'You cannot add empty comment.';
                            }
                            else {
                              String trimmedValue = value.trim();
                              if(trimmedValue.isEmpty) {
                                return 'You cannot add empty comment.';
                              }
                            }
                            return null;
                          },

                          onSaved: (value){
                            if(value != null){
                              _comment = value;
                            }
                          },


                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                _formKey.currentState!.save();
                              }

                              //If the user did not buy the item, cannot comment.
                              if(!userCheck()){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('ERROR'),
                                    content:  Text(
                                      'You should buy the product to add comment!',),
                                    actions: <Widget>[
                                      //
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              else if(_comment == ""){
                                print(_comment);
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('ERROR'),
                                    content:  Text(
                                      'Comment field empty!',),
                                    actions: <Widget>[
                                      //
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),);
                              }
                              //Can comment.
                              else{
                                //if(_formKey.currentState!.validate()){
                                //  _formKey.currentState!.save();
                                //}

                                await FirebaseFirestore.instance.collection("products").doc(widget.product.productRef).update({
                                  "comment": FieldValue.arrayUnion([_comment]),
                                });

                                await FirebaseFirestore.instance.collection("users").doc(widget.userInfo.id).update({
                                  "comments": FieldValue.arrayUnion([_comment]),
                                });

                              }
                            },

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                'Add Comment',
                                style:kLogButtonText,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Dimen.betweenMargin,),

                      Text("Comments ",
                        style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                        ),),

                      SizedBox(height: 7.0),

                      comments(),




                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
