import 'package:formula_ticket_flutter/model/objects/Purchase.dart';
import 'package:formula_ticket_flutter/model/objects/TicketInPurchase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/support/utils.dart';
import '../../colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/itemCounterWidget.dart';

class PurchaseCard extends StatelessWidget {
  Purchase purchase;
  int index;

  PurchaseCard({Key key,
    this.index,
    this.purchase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: AppColors.primaryColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return PurchaseDialog(ticketsInPurchase: purchase.ticketsInPurchase,);
              });
        },

        child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Order " + index.toString() + " contains " +
                          Utils.countTickets(purchase).toString() + " tickets",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AppText(
                        text: "Order date: " + DateFormat.yMd().add_jm().format(
                            purchase.purchaseTime),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                    SizedBox(
                      height: 12,
                    ),

                  ],
                ),
                AppText(
                    text: "Tap for more info",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ],
            )

        ),
      ),
    );
  }
}

class PurchaseDialog extends StatelessWidget {
  List<TicketInPurchase>  ticketsInPurchase;
  PurchaseDialog(
      {Key key,
        this.ticketsInPurchase})
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
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
              text: "This purchase contains ",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: 5,
            ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ticketsInPurchase.length,
                  itemBuilder: (context, index) {
                    return ItemOfPuchaseCard(
                      ticketInPurchase: ticketsInPurchase[index],
                    );
                  },
                ),

              ),
            SizedBox(
              height: 5,
            ),
            AppText(
              text: "Total Price\n\$"+Utils.getAllPrice(ticketsInPurchase).toString(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    ),
    );
  }
}


class ItemOfPuchaseCard extends StatelessWidget {
  TicketInPurchase ticketInPurchase;

  ItemOfPuchaseCard({Key key, this.ticketInPurchase, })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: ticketInPurchase.ticket.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 5,
                ),
                AppText(
                    text: '${DateFormat("dd, MMM").format(
                        ticketInPurchase.ticket.validFrom)} - ${DateFormat("dd, MMM")
                        .format(ticketInPurchase.ticket.validUntil)}',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
                SizedBox(
                  height: 12,
                ),
                AppText(
                    text: "Type: " + ticketInPurchase.ticket.type,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ],
            ),

            Column(
              children: [

                Spacer(
                  flex: 5,
                ),
                Container(
                  width: 70,
                  child: AppText(
                    text: "\$${Utils.getPrice(ticketInPurchase).toStringAsFixed(2)}",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.right,
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }

}




