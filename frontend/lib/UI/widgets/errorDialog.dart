import 'package:flutter/material.dart';

import '../../../../../Documents/Intellij/Formula_Ticket_Flutter/lib/UI/widgets/app_button.dart';
import '../../../../../Documents/Intellij/Formula_Ticket_Flutter/lib/UI/widgets/app_text.dart';
import '../../../../../Documents/Intellij/Formula_Ticket_Flutter/lib/UI/widgets/order_accepted_screen.dart';


class ErrorDialog extends StatelessWidget {
  String error;
  ErrorDialog(
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
        height: 300.0,
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
              flex: 2,
            ),
            AppText(
              text: "Oops! An error is occured",
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
              label: "Back",
              fontWeight: FontWeight.w600,
              onPressed: () {
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
