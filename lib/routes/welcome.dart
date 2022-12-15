import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:selma_sign_up/routes/feedView.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../main.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    if(user == null){
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SingleChildScrollView(
          child: SafeArea(
            maintainBottomViewPadding: false,
            child: Padding(
              padding: Dimen.buttonPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Center(
                    child: Padding(
                        padding: Dimen.buttonPadding,
                        child: Text(
                          'Welcome to',
                          style: kWelcomeTitle,
                        )
                    ),
                  ),


                  Center(
                    child: Padding(
                        padding: Dimen.buttonPadding,
                        child: Text(
                          'Sell-we',
                          style: kAppTitle,
                        )
                    ),
                  ),
                  SizedBox(height: 48,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/personal_signup');
                          },
                          child: Padding(
                            padding: Dimen.buttonPadding,
                            child: Text(
                              'CREATE PERSONAL ACCOUNT',
                              style:kFirstPageButton,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            onSurface: AppColors.textColor,
                            backgroundColor: AppColors.secondaryColor,
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),

                  SizedBox(height:16,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/corporate_signup');
                          },
                          child: Padding(
                            padding: Dimen.buttonPadding,
                            child: Text(
                              'CREATE CORPORATE ACCOUNT',
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
                      ),
                    ],
                  ),

                  SizedBox(height: Dimen.textFieldHeight),

                  Center(
                    child: Padding(
                        padding: Dimen.buttonPadding,
                        child: Text(
                          'Already registered? Log in:',
                          style: kLogText,
                        )
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Padding(
                            padding: Dimen.buttonPadding,
                            child: Text(
                              'Log in',
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
                  SizedBox(height:Dimen.textFieldHeight),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            auth.signInAnon();
                            Navigator.pushNamed(context, '/searchView');
                          },
                          child: Padding(
                            padding: Dimen.buttonPadding,
                            child: Text(
                              'Continue without an account',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.textColor,
                                fontSize: 16.0,
                                decorationThickness: 1.5,
                              ),
                            ),

                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    }else{
      return FeedView(analytics: MyApp.analytics, observer: MyApp.observer, products: [],);
    }
  }
}

