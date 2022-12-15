import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:selma_sign_up/models/notification.dart';
import 'package:selma_sign_up/cards/notification_tile.dart';
import 'package:selma_sign_up/services/auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {

  AuthService auth = AuthService();

  int count = 0;
  List<Notif> notifList = [
    Notif(text: 'Someone added your product to their wishlist!', date: '27.12.2021'),
    Notif(text: 'Someone added your product to their wishlist!', date: '26.12.2021'),
    Notif(text: '"X Brand" made a 25% discount on all of their products! Check it out on "Special Offers".', date: '25.12.2021'),
    Notif(text: '"Sabanci Gift Shop" gives a free mug for orders that are above 200TL! Check it out on "Special Offers".', date: '23.12.2021'),
    Notif(text: 'Someone added your product to their wishlist!', date: '23.12.2021'),
    Notif(text: 'Welcome to SellWe! We are so happy that you joined us!', date: '21.12.2021'),
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('build');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications:',
          style: kAppBarTitleLabel,
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 5.0,
      ),

      body: PageView(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height:8,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children:
                    notifList.map((notif) => NotifTile(notif: notif,
                      delete: () {
                        setState(() {
                          notifList.remove(notif);
                        });
                      },)
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}