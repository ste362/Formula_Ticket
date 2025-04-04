
import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text.dart';

class RegistrationFail extends StatelessWidget {


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


            AppText(
              text: "Registration fail \nEmail already exists",
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            Spacer(
              flex: 1,
            ),

            AppButton(
              label: "Back",
              fontWeight: FontWeight.w600,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Spacer(
              flex: 1,
            ),


          ],
        ),
      ),
    );
  }
}