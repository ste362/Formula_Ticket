import 'package:formula_ticket_flutter/UI/pages/cart/cart_screen.dart';
import 'package:formula_ticket_flutter/model/objects/Ticket.dart';
import 'package:flutter/material.dart';
import '../../../model/support/utils.dart';
import '../../widgets/app_text.dart';
import '../../widgets/itemCounterWidget.dart';
import 'package:intl/intl.dart';

class ChartItemWidget extends StatefulWidget {
  ChartItemWidget({Key key, this.ticket, Function this.remove}) : super(key: key);
final Function remove;
  final Ticket ticket;
  @override
  _ChartItemWidgetState createState() => _ChartItemWidgetState();
}

class _ChartItemWidgetState extends State<ChartItemWidget> {
  final double height = 110;

  final Color borderColor = Color(0xffE2E2E2);

  final double borderRadius = 18;



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
                  text: widget.ticket.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 5,
                ),
                AppText(
                    text:  '${DateFormat("dd, MMM").format(widget.ticket.validFrom)} - ${DateFormat("dd, MMM").format(widget.ticket.validUntil)}',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
                SizedBox(
                  height: 12,
                ),
                AppText(
                    text: "Type: "+widget.ticket.type,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ],
            ),
            ItemCounterWidget(
              onAmountChanged: (newAmount) {
                setState(() {
                  Utils.cart.update(this.widget.ticket, (value) => newAmount);
                });
              },
              maxAmount:widget.ticket.qta,
              startAmount: Utils.cart[this.widget.ticket],
            ),
            Column(
              children: [
                IconButton(
                  onPressed:(){
                    this.widget.remove(this.widget.ticket);
                  },
                  icon:Icon(
                    Icons.delete,

                    color: Colors.black54,
                    size: 25,
                  ),
                ),
                Spacer(
                  flex: 5,
                ),
                Container(
                  width: 70,
                  child: AppText(
                    text: "\$${getPrice().toStringAsFixed(2)}",
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


  double getPrice() {
    return widget.ticket.price * Utils.cart[this.widget.ticket];
  }
}
