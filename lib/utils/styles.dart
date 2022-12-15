import 'package:flutter/material.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

//for first page with log or sign options
final kAppTitle = GoogleFonts.pacifico(
  fontSize: 65.0,
  color: AppColors.purplePrimary,
);
final kWelcomeTitle = GoogleFonts.pacifico(
  fontSize: 28.0,
  color: AppColors.textColor,
);
final kAppBarAppTitle = GoogleFonts.pacifico(
  fontSize: 51.0,
  color: AppColors.purplePrimary,
);
final kFirstPageButton = GoogleFonts.poppins(
  fontSize: 16.0,
  color: Colors.black,
);

//for log in and sign in pages
final kLogTitle = GoogleFonts.poppins(
  fontSize: 32.0,
  color: AppColors.textColor,
);
final kTextFieldTitle = GoogleFonts.dmSans(
  fontSize: 12.0,
  color: Colors.black,
);
final kLogText = GoogleFonts.dmSans(
  fontSize: 16.0,
  color: AppColors.textColor,
);
final kLogButtonText = GoogleFonts.openSans(
  fontSize: 14.0,
  color: Colors.white,
);
final kBoldLogText = GoogleFonts.dmSans(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: AppColors.textColor,
);

//for main pages
final kAppBarTitleLabel = GoogleFonts.openSans(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  color: AppColors.textColor,
);
final kDiscountBold = GoogleFonts.ptSerif(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: AppColors.purplePrimary,
);
final kBrandName = GoogleFonts.ptSerif(
  fontSize: 23.0,
  fontWeight: FontWeight.bold,
  color: AppColors.textColor,
);

//for categories
final kSearchBar = GoogleFonts.ptSerif(
  fontSize: 20.0,
  color: AppColors.textColor,
);
final kCategories = GoogleFonts.ptSerif(
  fontSize: 24.0,
  color: AppColors.textColor,
);

//for main use of text in profile and product page
final kProMainBold = GoogleFonts.openSans(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: AppColors.textColor,
);
final kProMain = GoogleFonts.openSans(
  fontSize: 18.0,
  color: AppColors.textColor,
);
final kProButtonsMain = GoogleFonts.openSans(
  fontSize: 18.0,
  color: Colors.white,
);
final kProProductPage = GoogleFonts.openSans(
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
  color: AppColors.textColor,
);

//for card view of products
final kProductCardPrice = GoogleFonts.openSans(
  fontSize: 11.8,
  color: AppColors.purplePrimary,
);
final kProductCardText = GoogleFonts.openSans(
  fontSize: 14.0,
  color: AppColors.textColor,
);
final kNotifText = GoogleFonts.openSans(
  fontSize: 18.0,
  color: AppColors.textColor,
);
