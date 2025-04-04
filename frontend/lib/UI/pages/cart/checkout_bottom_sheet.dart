import 'dart:async';
import 'dart:convert';

import 'package:formula_ticket_flutter/UI/widgets/order_accepted_screen.dart';
import 'package:formula_ticket_flutter/model/objects/Purchase.dart';
import 'package:formula_ticket_flutter/model/objects/TicketInPurchase.dart';
import 'package:flutter/material.dart';

import '../../../model/Model.dart';
import '../../../model/objects/Ticket.dart';
import '../../../model/objects/User.dart';
import '../../../model/support/exceptions/exceptions.dart';
import '../../../model/support/utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/order_failed_dialog.dart';

class CheckoutBottomSheet extends StatefulWidget {
  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: new Wrap(
        children: <Widget>[
          Row(
            children: [
              AppText(
                text: "Checkout",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 25,
                  ))
            ],
          ),
          SizedBox(
            height: 45,
          ),
          getDivider(),
          checkoutRow("Delivery", trailingText: "Select Method"),
          getDivider(),
          checkoutRow("Payment", trailingWidget: Icon(Icons.payment)),
          getDivider(),
          checkoutRow("Promo Code", trailingText: "Pick Discount"),
          getDivider(),
          checkoutRow("Total Cost", trailingText: "\$"+Utils.totalPrice().toString()),
          getDivider(),
          SizedBox(
            height: 30,
          ),
          termsAndConditionsAgreement(context),
          Container(
            margin: EdgeInsets.only(
              top: 25,
            ),
            child: AppButton(
              label: "Place Order",
              fontWeight: FontWeight.w600,
              padding: EdgeInsets.symmetric(
                vertical: 25,
              ),
              onPressed: () {
                onPlaceOrderClicked();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'By placing an order you agree to our',
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 14,
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
                text: " Terms",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(text: " And"),
            TextSpan(
                text: " Conditions",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
    );
  }

  Widget checkoutRow(String label,
      {String trailingText, Widget trailingWidget}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        children: [
          AppText(
            text: label,
            fontSize: 18,
            color: Color(0xFF7C7C7C),
            fontWeight: FontWeight.w600,
          ),
          Spacer(),
          trailingText == null
              ? trailingWidget
              : AppText(
                  text: trailingText,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
          )
        ],
      ),
    );
  }

  void onPlaceOrderClicked() {
    List<TicketInPurchase> ticketsInPurchase=[];
    for(Ticket t in Utils.cart.keys){
      ticketsInPurchase.add(TicketInPurchase(ticket: t,quantity: Utils.cart[t]));
    }

    //print("DATA CORRENTE"+DateTime.now().toString() );
    Purchase purchase=Purchase(purchaseTime: DateTime.now(),user: Utils.user, ticketsInPurchase: ticketsInPurchase,price: Utils.totalPrice());
    //print("purchase:"+purchase.toJson().toString());
    //print("json encode+ "+json.encode(purchase.toJson()).toString());
    try {
      Model.sharedInstance.addPurchase(purchase).then((result) {
        if(result!=null) {
          Utils.cart.clear();
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => OrderAcceptedScreen(message:"Order is correctly placed"),
          )
          );

        }
        else{
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => OrderFailedDialogue(error:"Something went wrong"),
          ));
        }
      });
    } on ProductQuantityUnavailableException{
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => OrderFailedDialogue(error:"Product unavailable"),
      ));
    }
    //Navigator.pop(context);

    /*showDialog(
        context: context,
        builder: (BuildContext context) {
          //return OrderFailedDialogue();
          return null;
        });

     */
  }
}
