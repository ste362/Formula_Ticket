import 'package:flutter/material.dart';

import 'app_button.dart';
import 'app_text.dart';
import 'order_accepted_screen.dart';


class OrderFailedDialogue extends StatelessWidget {
  String error;
  OrderFailedDialogue(
      {Key key,
        this.error})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      insetPadding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        height: 600.0,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Image(
                  image: AssetImage("assets/images/order_failed_image.png")),
            ),
            Spacer(
              flex: 5,
            ),
            AppText(
              text: "Oops! Order Failed",
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            Spacer(
              flex: 2,
            ),
            AppText(
              text: error,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff7C7C7C),
            ),
            Spacer(
              flex: 8,
            ),
            AppButton(
              label: "Back To Cart",
              fontWeight: FontWeight.w600,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            Spacer(
              flex: 4,
            ),


          ],
        ),
      ),
    );
  }
}
