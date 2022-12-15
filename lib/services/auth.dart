import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:selma_sign_up/models/product.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference ProCollection = FirebaseFirestore.instance.collection('products');

  String _message = "";


  User? _userFromFirebase(User? user) {
    return user ?? null;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future getCurrentUser() async{
    return await FirebaseAuth.instance.currentUser;
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;

      if(result != null && result.user != null){
        userCollection.doc(result.user!.uid).set({
          "username" : 'Anonymous',
          "mail" : 'anon@gmail.com',
          "token" : 'anon@gmail.com',
          "profilePicture": "",
          "productSold" : [],
          "productsSelling" : [],
          "productsPurchased": [],
          "productsOnSale" : [],
          "productsInCard": [],
          "productsBookmarked": [],
          "comments" : [],
          "raterCount" : 0,
          "rateSum" : 0,
          "activation": true,
        });
      }
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signupWithMailAndPass(String mail, String pass, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;

      if(result != null && result.user != null){
        userCollection.doc(result.user!.uid).set({
          "username" : username,
          "mail" : mail,
          "token" : mail,
          "profilePicture": "",
          "productSold" : [],
          "productsSelling" : [],
          "productsPurchased": [],
          "productsOnSale" : [],
          "productsInCard": [],
          "productsBookmarked": [],
          "comments" : [],
          "raterCount" : 0,
          "rateSum" : 0,
          "activation": true,
        });
      }
      return _userFromFirebase(user);

    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        print("Password is too weak.");
      } else if(e.code == 'email-already-in-use'){
        print("The account already exists for that email.");
      }
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future loginWithMailAndPass(String mail, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;


      return _userFromFirebase(user);

    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found"){
        print("User not found. Please sign up or try again.");
      }
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = result.user;

    if(result != null && result.user != null){
      userCollection.doc(result.user!.uid).set({
        "username" : user!.displayName,
        "mail" : user.email,
        "token" : user.email,
        "profilePicture": user.photoURL,
        "productSold" : [],
        "productsSelling" : [],
        "productsPurchased": [],
        "productsOnSale" : [],
        "productsInCard": [],
        "productsBookmarked": [],
        "comments" : [],
        "raterCount" : 0,
        "rateSum" : 0,
        "activation": true,
      });
    }

    return _userFromFirebase(user);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    User? user = result.user;

    if(result != null && result.user != null){
      userCollection.doc(result.user!.uid).set({
        "username" : user!.displayName,
        "mail" : user.email,
        "token" : user.email,
        "profilePicture": user.photoURL,
        "productSold" : [],
        "productsSelling" : [],
        "productsPurchased": [],
        "productsOnSale" : [],
        "productsInCard": [],
        "productsBookmarked": [],
        "comments" : [],
        "raterCount" : 0,
        "rateSum" : 0,
        "activation": true,
      });
    }

    // Once signed in, return the UserCredential
    return result;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOutAnon() async {
    try {
      User? user = await _auth.currentUser;

      if(user != null){
        await userCollection.doc(user.uid).delete();
      }

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  Future deactivateUser() async{
    User? user = await _auth.currentUser;
    if(user != null){
      await userCollection.doc(user.uid).update({
        "activation": false,
      });
    }
    return;
  }

  Future activateUser() async{
    User? user = await _auth.currentUser;
    if(user != null){
      await userCollection.doc(user.uid).update({
        "activation": true,
      });
    }
    return;
  }

  Future deleteUser() async {
    try {
      User? user = await _auth.currentUser;

      if(user != null){
        await userCollection.doc(user.uid).delete();
      }
      user!.delete();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}