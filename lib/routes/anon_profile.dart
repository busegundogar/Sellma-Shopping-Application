import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';

class AnonProfile extends StatefulWidget {
  const AnonProfile({Key? key}) : super(key: key);

  @override
  _AnonProfileState createState() => _AnonProfileState();
}

class _AnonProfileState extends State<AnonProfile> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Text(
                'My Profile',
                style: kAppBarTitleLabel,
              ),
            ]
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You are not logged in!",
                    style: TextStyle(
                      color: AppColors.purplePrimary,
                      fontSize: 35.0,
                    ))
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please log in to view your profile.",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 17,
                  ),)
              ],
            ),
            SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: (){
                      auth.signOut();
                      Navigator.pushNamed(context, '/welcome');
                    },
                    child: Text(
                      "Go to login page ->",
                      style: TextStyle(
                          color: AppColors.purplePrimary,
                          fontSize: 14
                      ),))
              ],
            ),
            SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}