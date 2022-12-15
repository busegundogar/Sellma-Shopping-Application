import 'package:flutter/material.dart';
import 'package:selma_sign_up/models/discount.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/utils/dimension.dart';


class DiscountTile extends StatelessWidget {

  final String discount;

  const DiscountTile({
    required this.discount
  });



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                child: Image.network(discount),
              ),
            ),

          ],
        ),
      ),
    );
  }
}