import 'package:formula_ticket_flutter/model/support/extensions/StringCapitalization.dart';
import 'package:flutter/material.dart';

import '../../model/objects/Ticket.dart';
import '../Login/login_screen.dart';
import '../../model/support/utils.dart';
import 'app_button.dart';
import 'app_text.dart';
import 'itemCounterWidget.dart';
import 'order_accepted_screen.dart';

class TicketAvailable extends StatefulWidget {

  final Ticket ticket;
  const TicketAvailable({Key key,  this.ticket}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_TicketAvailableState();

}

class _TicketAvailableState extends State<TicketAvailable>{

  num _amount =1;

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
              text: "Ticket Available",
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            Spacer(
              flex: 1,
            ),
            Align(
              alignment: Alignment.center,
              child:AppText(
                text:  widget.ticket.name.capitalize,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444),
                textAlign:TextAlign.start,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Align(
              alignment: Alignment.centerLeft,
            child:AppText(
              text: "Ticket description: \n" + widget.ticket.description,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff7C7C7C),
              textAlign:TextAlign.start,
            ),
            ),
            Spacer(
              flex: 2,
            ),
            AppText(
              text: "Are available: " + widget.ticket.qta.toString()+ " tickets",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff7C7C7C),
            ),
            Spacer(
              flex: 1,
            ),
            AppText(
              text: "Price "+widget.ticket.price.toString()+"\$ each",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff7C7C7C),
            ),
            Spacer(
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Enter quantity",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff7C7C7C),
                ),
                ItemCounterWidget(
                  onAmountChanged: (newAmount) {
                    setState(() {
                      _amount = newAmount;
                    });
                  },
                  maxAmount:widget.ticket.qta,
                ),
              ],
            ),

            Spacer(
              flex: 2,
            ),
            AppText(
              text: "Total Price: ${getPrice().toStringAsFixed(2)}\$",
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: Color(0xff7C7C7C),
            ),
            Spacer(
              flex: 4,
            ),
            AppButton(
              label: "Add to cart",
              fontWeight: FontWeight.w600,
              onPressed: () {

                if(!Utils.IS_LOGGED){
                  Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LoginPage();
                    },
                  ));
                }
                else {
                  if (Utils.cart.containsKey(widget.ticket)) {
                    Utils.cart.update(
                        widget.ticket, (value) => _amount + Utils.cart[widget.ticket]);
                  }
                  else {
                    Utils.cart.putIfAbsent(widget.ticket, () => _amount);
                  }
                  //print(Utils.cart);
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return OrderAcceptedScreen(message: "Tickets correctly added to cart",);
                    },
                  ));
                }
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
  double getPrice() {
    return this.widget.ticket.price * _amount;
  }
}





class TicketNotAvailable extends StatelessWidget {


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
              text: "Ticket not available!!",
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