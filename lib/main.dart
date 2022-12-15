import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'package:selma_sign_up/routes/addProduct.dart';
import 'package:selma_sign_up/routes/corporate_signup.dart';
import 'package:selma_sign_up/routes/editProfilePage.dart';
import 'package:selma_sign_up/routes/feedView.dart';
import 'package:selma_sign_up/routes/login.dart';
import 'package:selma_sign_up/routes/notificationPage.dart';
import 'package:selma_sign_up/routes/personal_signup.dart';
import 'package:selma_sign_up/routes/profilePage.dart';
import 'package:selma_sign_up/routes/searchView.dart';
import 'package:selma_sign_up/routes/shoppingCart.dart';
import 'package:selma_sign_up/routes/walkthrough.dart';
import 'package:selma_sign_up/routes/welcome.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


int? initScreen;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //Forces app to crash
  //FirebaseCrashlytics.instance.crash();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen',1);

  runApp(_MyFirebaseAppState());
}



class _MyFirebaseAppState extends StatefulWidget {
  const _MyFirebaseAppState({Key? key}) : super(key: key);

  @override
  _MyFirebaseAppStateState createState() => _MyFirebaseAppStateState();
}

class _MyFirebaseAppStateState extends State<_MyFirebaseAppState> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return MaterialApp(
              home: Scaffold(
                body:Center(
                  child: Text('No Firebase Connection: ${snapshot.error.toString()}'),
                ),
              ),
            );

          }
          if(snapshot.connectionState == ConnectionState.done){
            print("Firebase connected");
            return MaterialApp(
              home: MyApp(),
            );
          }

          //Loading Case
          return MaterialApp(
            home: Center(
              child: Text('Connecting to Firebase'),
            ),
          );

        });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],

        home: FeedView(analytics:analytics, observer:observer, products: [],),
        initialRoute: initScreen == 0 || initScreen == null ? '/walkthrough' : '/welcome',
        routes: {
          '/walkthrough': (context) => WalkThrough(analytics:analytics, observer:observer),
          '/welcome': (context) => Welcome(analytics:analytics, observer:observer),
          '/login': (context) => Login(analytics:analytics, observer:observer),
          '/personal_signup': (context) => PersonalSignUp(analytics:analytics, observer:observer),
          '/corporate_signup': (context) => CorporateSignUp(analytics:analytics, observer:observer),
          '/feedView' : (context) => FeedView(analytics:analytics, observer:observer, products: [],),
          //'/searchView' : (context) => SearchView(analytics: analytics, observer: observer),
          //'/profilePage' : (context) => ProfilePage(analytics: analytics, observer: observer),
          '/editProfilePage' : (context) => EditProfilePage(analytics: analytics, observer: observer),
          '/notificationView' : (context) => NotifPage(analytics: analytics, observer: observer),
          //'/cart' : (context) => ShoppingCart(analytics: analytics, observer: observer),
          //'/addProduct' : (context) => AddProduct(analytics: analytics, observer: observer),
        },
      ),
    );
  }
}


