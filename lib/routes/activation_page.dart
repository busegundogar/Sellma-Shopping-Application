import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';

class ActivationPage extends StatefulWidget {
  const ActivationPage({Key? key}) : super(key: key);

  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
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
                Text("Account deactivated!",
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
                Text("Please activate your account to see your profile.",
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
                      auth.activateUser();
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('ACTIVATED'),
                          content:  Text(
                            'User activated. Please log in.',),
                          actions: <Widget>[
                            //
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),);
                    },
                    child: Text(
                      "Activate Account",
                      style: TextStyle(
                          color: AppColors.purplePrimary,
                          fontSize: 14,
                      ),))
              ],
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