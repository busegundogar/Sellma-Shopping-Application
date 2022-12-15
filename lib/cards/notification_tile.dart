import 'package:flutter/material.dart';
import 'package:selma_sign_up/models/notification.dart';
import 'package:selma_sign_up/utils/colors.dart';
import 'package:selma_sign_up/utils/styles.dart';
import 'package:selma_sign_up/utils/dimension.dart';


class NotifTile extends StatelessWidget {

  final Notif notif;
  final VoidCallback delete;

  const NotifTile({
    required this.notif,
    required this.delete
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
            Icon(Icons.notifications,
                color: AppColors.purplePrimary),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                notif.text,
                style: kNotifText,
              ),
            ),

            Row(
              children: [
                //Spacer(),
                Text(
                  notif.date,
                  textAlign: TextAlign.right,
                  style: kProductCardText,
                ),

                Spacer(),


                IconButton(
                  onPressed: delete,
                  padding: EdgeInsets.all(0),
                  iconSize: 15,
                  splashRadius: 22,
                  color: Colors.red,
                  icon: Icon(
                    Icons.delete,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}