import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/main.dart';
import 'package:selma_sign_up/models/discount.dart';
import 'package:selma_sign_up/cards/discount_tile.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/routes/shoppingCart.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:selma_sign_up/services/db.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/routes/searchView.dart';

class FeedView extends StatefulWidget {
  List<Product?> products;
  FeedView({Key? key, required this.analytics, required this.observer, required this.products}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {

  AuthService auth = AuthService();


  int count = 0;


  List<String> imgs = [
    'https://cdn.dsmcdn.com/marketing/datascience/automation/2022/1/21/En_Woman_Desktop_Main_B610_202201212018.jpg',
    'https://cdn.dsmcdn.com/marketing/datascience/automation/2022/1/21/En_Man_Desktop_Main_B222_202201212018.jpg',
    'https://cdn.dsmcdn.com/marketing/datascience/automation/2022/1/21/En_Woman_Desktop_Superdeal_B620_202201212018.jpg',
    'https://cdn.dsmcdn.com/marketing/datascience/automation/2022/1/21/En_Man_Desktop_Basics_B232_202201212018.jpg',
    'https://cdn.dsmcdn.com/marketing/datascience/automation/2022/1/21/En_Man_Desktop_Jacket_B227_202201212018.jpg',
    'https://cdn.dsmcdn.com/marketing/datascience/automation/2022/1/21/En_Woman_Desktop_Blouses_B615_202201212018.jpg',
  ];

  @override
  void initState() {
    super.initState();
  }

  List<Product?> Products = [];
  List<Product?> myProducts = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) async{
    DocumentSnapshot result = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      _selectedIndex = index;
    });
    if (index == 0)
    {
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
    else if (index == 1)
    {
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
          print(widget.products[i]!.sellerRef);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchView(
                  analytics: MyApp.analytics,
                  observer: MyApp.observer,
                  products: Products,
                  userInfo: result
                ),
          ),
        );
      });
    }
    else if (index == 2)
    {
      //DocumentSnapshot result =  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid ).get();
      FirebaseFirestore.instance.collection("products").get().then((querySnapshot) async {
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

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed:() async{

            if(_auth.currentUser!.isAnonymous){
              await auth.signOutAnon();
            }
            else{
              await auth.signOut();
            }

            Navigator.pushNamed(context, '/welcome');
          }, icon: const Icon(Icons.logout),
        ),
        centerTitle: true,
        title: Text(
          'Special Offers',
          style: kAppBarTitleLabel,
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 5.0,
      ),

      body: PageView(
        //controller: pc;
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height:8,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children:
                    imgs.map((discount) => DiscountTile(discount: discount)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
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