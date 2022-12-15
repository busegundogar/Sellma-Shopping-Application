import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/dimension.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {

  int currentPage = 0;
  int lastPage = 3;

  List<String> headings = [
    'New app for commerce',
    'Sign up easily',
    'Create your profile',
    'Start shopping and selling'
  ];
  List<String> captions = [
    'Just everything you wanted',
    '    Sign up with your e-mail, Google or Facebook accounts    ',
    'Attract new buyers to you',
    'It\'s that easy!'
  ];

  List<String> images = [
    'https://www.eusmecentre.org.cn/sites/default/files/imagecache/article_banner/New%20E%20Commerce%20Report%20Image.PNG',
    'https://www.binarytattoo.com/wp-content/uploads/2015/02/FB-and-Google-Sign-in-page.png',
    'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_1280.png',
    'https://4.bp.blogspot.com/-79nxMUGzyHk/XOcWE90z2TI/AAAAAAAACpk/_Er5NWgA8igcwxf_YTHlGaPwmUgtoJKFwCLcBGAs/s1600/shopping-bag-pay.jpg',
  ];

  void nextPage() {
    if(currentPage < lastPage) {
      setState(() {
        currentPage += 1;
      });
    }
    else if(currentPage == lastPage) {
      Navigator.pushNamed(context, '/welcome');
    }
  }

  void prevPage() {
    if(currentPage > 0) {
      setState(() {
        currentPage -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Sell-we',
          style: kAppBarAppTitle,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimen.betweenMargin),
                child: Text(
                  headings[currentPage],
                  style: kAppBarTitleLabel,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(),



            Container(
              height: Dimen.imageContainerHeight,
              child: CircleAvatar(
                backgroundImage: NetworkImage(images[currentPage]),
                radius: Dimen.circleAvatarRadius,
                backgroundColor: AppColors.purplePrimary,
              ),
            ),

            SizedBox(),

            Center(
              child: Text(
                captions[currentPage],
                style: kSearchBar,
                textAlign: TextAlign.center,
              ),
            ),




            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimen.largeMargin),
              child: Container(
                height: 80,
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: prevPage,
                      child: Text(
                        'Prev',
                        style: kFirstPageButton,
                      ),
                    ),


                    Spacer(),


                    Text(
                      '${currentPage+1}/${lastPage+1}',
                      style: TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),


                    Spacer(),


                    OutlinedButton(
                      onPressed: nextPage,
                      child: Text(
                        'Next',
                        style: kFirstPageButton,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
