import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:selma_sign_up/routes/feedView.dart';
import 'package:selma_sign_up/routes/searchView.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:selma_sign_up/services/db.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../main.dart';


class CorporateSignUp extends StatefulWidget{
  const CorporateSignUp({Key? key,required this.analytics,required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  _CorporateSignUp createState() => _CorporateSignUp();
}

class _CorporateSignUp extends State<CorporateSignUp> {

  final _formKey = GlobalKey<FormState>();
  String corporateName = "";
  String password = "";
  String mail = "";
  String _message = "";

  AuthService auth = AuthService();

  void setMessage(String msg){
    setState(() {
      _message = msg;
    });
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final user = Provider.of<User?>(context);

    DBService db = DBService();
    String token = "";

    if (user == null){
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor,),
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
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:Dimen.betweenMargin),
                        child: Text(
                          'Create Corporate',
                          style: kLogTitle,
                        ),
                      ),
                    ),


                    Center(
                      child: Text(
                        "Account",
                        style: kLogTitle,
                      ),
                    ),

                    SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("CORPORATE NAME (This will be your corporate's username)",
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
                            decoration: InputDecoration(
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
                                return 'Corporate Name field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'Corporate Name field cannot be empty';
                                }
                              }
                              return null;
                            },
                            onSaved: (value){
                              if(value != null){
                                corporateName = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("EMAIL",
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
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,

                            validator: (value) {
                              if(value == null) {
                                return 'E-mail field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'E-mail field cannot be empty';
                                }
                                if(!EmailValidator.validate(trimmedValue)) {
                                  return 'Please enter a valid email';
                                }
                              }
                              return null;
                            },

                            onSaved: (value){
                              if(value != null){
                                mail = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimen.betweenMargin),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("PASSWORD",
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
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,

                            validator: (value) {
                              if(value == null) {
                                return 'Password field cannot be empty';
                              }
                              else {
                                String trimmedValue = value.trim();
                                if(trimmedValue.isEmpty) {
                                  return 'Password field cannot be empty';
                                }
                                if(trimmedValue.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                              }
                              return null;
                            },

                            onSaved: (value) {
                              if(value != null) {
                                password = value;
                              }
                            },

                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimen.sideMargin),


                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                print("corporateName: "+corporateName +'\nMail: '+mail+"\nPass: "+password);
                                _formKey.currentState!.save();
                                print("corporateName: "+corporateName +'\nMail: '+mail+"\nPass: "+password);

                                auth.signupWithMailAndPass(mail, password, corporateName);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Signing up')));
                              }

                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimen.betweenMargin),
                              child: Text(
                                'Sign Up',
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

                    SizedBox(height:Dimen.betweenMargin),

                    Text(
                      _message,
                      style: TextStyle(
                        color: AppColors.red,
                      ),
                    ),


                    SizedBox(height:Dimen.betweenMargin),

                    Center(
                      child: Text(
                        "OR",
                        style: kLogText,
                      ),
                    ),

                    SizedBox(height:Dimen.betweenMargin),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: SignInButton(
                              Buttons.Google,
                              text: 'Sign up with Google',
                              onPressed: () {
                                auth.signInWithGoogle();
                              },

                            )
                        ),
                      ],
                    ),

                    SizedBox(height: Dimen.betweenMargin),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: SignInButton(
                              Buttons.Facebook,
                              text: 'Sign up with Facebook',
                              onPressed: (){
                                auth.signInWithFacebook();
                              },
                            )
                        ),
                      ],
                    ),

                    SizedBox(height:Dimen.betweenMargin),
                  ],
                ),
              ),
            ),
          ),
        ),


      );
    } else{
      return FeedView(analytics: MyApp.analytics, observer: MyApp.observer, products: [],);
    }


  }

}

