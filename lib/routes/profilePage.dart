import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:selma_sign_up/cards/product_tile.dart';
import 'package:selma_sign_up/cards/products_on_sale_tile.dart';
import 'package:selma_sign_up/main.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/activation_page.dart';
import 'package:selma_sign_up/routes/addProduct.dart';
import 'package:selma_sign_up/routes/anon_profile.dart';
import 'package:selma_sign_up/routes/comment_page.dart';
import 'package:selma_sign_up/routes/searchView.dart';
import 'package:selma_sign_up/routes/shoppingCart.dart';
import 'package:selma_sign_up/routes/wishlist_page.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:selma_sign_up/utils/styles.dart';

import 'feedView.dart';
import 'order_page.dart';

class ProfilePage extends StatefulWidget {

  DocumentSnapshot<Object?> userInfo;
  List<Product?> products;
  ProfilePage({Key? key, required this.analytics, required this.observer,  required this.userInfo, required this.products}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference prods = FirebaseFirestore.instance.collection('products');
  final firestoreInstance = FirebaseFirestore.instance;
  AuthService auth = AuthService();


  List<Product> productsOnSale = [];
  List<Product> soldProducts = [];

  List<Product?> Products = [];
  List<Product?> myProducts = [];
  int _selectedIndex = 3;



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
                  userInfo: result,
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

    """  if(result['activation'] == false){
        return Text('User deactivated. You cannot see these pages.');
      }""";

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

  List<Product>? OnSale(){
    List<Product> onSales = [];

    List<dynamic> currentSales = widget.userInfo["productsOnSale"];

    for(var elmt in widget.products){
      for(var id in currentSales){
        if(id == elmt!.productRef){
          onSales.add(elmt);
        }
      }
    }
    return onSales;
  }

  List<Product>? Sold(){
    List<Product> sold = [];

    List<dynamic> currentSales = widget.userInfo["productSold"];

    for(var elmt in widget.products){
      for(var id in currentSales){
        if(id == elmt!.productRef){
          sold.add(elmt);
        }
      }
    }
    return sold;
  }


  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth.currentUser!.isAnonymous){
      return AnonProfile();
    }
    if(widget.userInfo['activation'] == false){
      return ActivationPage();
    }

    List<Product>? userOnSale = OnSale();
    List<Product>? userSold = Sold();


    String _username = widget.userInfo["username"].toString();
    String imageUrl = widget.userInfo["profilePicture"];

    double _rateSum = double.parse(widget.userInfo["rateSum"].toString());
    double _raterCount = double.parse(widget.userInfo["raterCount"].toString());
    double _initialRating = double.parse((_rateSum/_raterCount).toStringAsFixed(2));

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Text(
              'My Profile',
              style: kAppBarTitleLabel,
            ),


            SizedBox(width: 25.0,),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
              child: OutlinedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/editProfilePage');
                  //go to edit profile page
                },
                child: Text(
                  'Edit Profile',
                  style: kProButtonsMain,
                ),

                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.textColor,
                ),
              ),
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
            child: Column(

              children: [
                SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Container(
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 50,
                        backgroundColor: AppColors.purplePrimary,
                      ),
                    ),

                    SizedBox(width: 25.0),



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${_username}",
                          style: kProMainBold,
                        ),

                        SizedBox(height: 8.0,),


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
                                  'Successfully gave $rating stars to @$_username',),
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

                        SizedBox(height: 1.0,),

                        Text(
                          "${'Average rate of user: $_initialRating'}",
                          style: kProductCardText,
                        ),
                      ],
                    ),
                  ],
                ),


                SizedBox(height: Dimen.betweenMargin),
                Divider(
                  color: AppColors.textColor,
                  thickness: 5.0,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/notificationView');
                          },
                          icon: Icon(
                              Icons.notifications
                          ),
                        ),
                        Text(
                          'Notifications',
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  CommentPage(
                                    analytics: MyApp.analytics,
                                    observer: MyApp.observer,
                                    userInfo: widget.userInfo,
                                    products: widget.products,
                                  ),
                            ),);

                          },
                          icon: Icon(
                              Icons.comment
                          ),
                        ),
                        Text(
                          'Comments',
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  OrderPage(
                                    analytics: MyApp.analytics,
                                    observer: MyApp.observer,
                                    userInfo: widget.userInfo,
                                    products: widget.products,
                                  ),
                            ),);
                          },
                          icon: Icon(
                              Icons.shopping_bag
                          ),
                        ),
                        Text(
                          'Orders',
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  WishlistPage(
                                    analytics: MyApp.analytics,
                                    observer: MyApp.observer,
                                    userInfo: widget.userInfo,
                                    products: widget.products,
                                  ),
                            ),);
                          },
                          icon: Icon(
                              Icons.favorite
                          ),
                        ),
                        Text(
                          'Wishlist',
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height:Dimen.betweenMargin),
                Divider(
                    color: AppColors.textColor,
                    thickness: 5.0),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Products on Sale',
                      style: kProMainBold,
                    ),
                  ],
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                      children: [
                        Wrap(
                          children: userOnSale!.map((product) => SaleProductTile(product: product, products: widget.products, observer: MyApp.observer, analytics: MyApp.analytics,userInfo: widget.userInfo,)).toList(),

                        ),
                      ]
                  ),
                ),

                SizedBox(height : 25.0),
                Divider(
                    color: AppColors.textColor,
                    thickness: 5.0
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sold Products',
                      style: kProMainBold,
                    ),
                  ],
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                      children: [
                        Wrap(
                          children: userSold!.map((product) => ProductTile(product: product, products: widget.products, observer: MyApp.observer, analytics: MyApp.analytics,userInfo: widget.userInfo)).toList(),
                        ),
                      ]
                  ),
                ),

                SizedBox(height: 25.0),
                Divider(color: AppColors.textColor,
                    thickness: 5.0
                ),
                SizedBox(height: 8.0),

                //Comment Requests
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: (){
                        auth.deactivateUser();
                        Navigator.pushNamed(context, '/welcome');
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Deactivate Account',
                          style:kFirstPageButton,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Dimen.betweenMargin),

                //Delete Account
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        auth.deleteUser();
                        Navigator.pushNamed(context, '/welcome');
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Delete Account',
                          style:kFirstPageButton,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Dimen.betweenMargin),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => AddProduct(
                  analytics: widget.analytics,
                  observer: widget.observer,
                  userInfo: widget.userInfo,
                  products: widget.products)));
        },
        backgroundColor: AppColors.purplePrimary,
        child: Icon(Icons.add_rounded),
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
