import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String mail = "";

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
    print(fileName);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    try {
      await firebaseStorageRef.putFile(File(_image!.path));
      print("Upload complete");

      String? imageURL;
      await firebaseStorageRef.getDownloadURL().then((fileURL){
        imageURL = fileURL;
      });

      userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "profilePicture" : imageURL,
      });

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
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: kAppBarTitleLabel,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: Dimen.sideMargin),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
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
                  ),

                  const SizedBox(width: 20,),

                  OutlinedButton(

                    onPressed: () {
                      if(_image != null){
                        uploadImageToFirebase(context);
                      }
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Save Profile Picture',
                        style:kLogButtonText,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("E-MAIL",
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
                                  return 'Please enter a valid e-mail';
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
                  ],
                ),
              ),

              const SizedBox(height: Dimen.betweenMargin),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(

                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(mail);
                          auth.sendPasswordResetEmail(email: mail);
                        }
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Send Request to Reset Password',
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
            ],
          ),
        ),
      ),
    );
  }
}