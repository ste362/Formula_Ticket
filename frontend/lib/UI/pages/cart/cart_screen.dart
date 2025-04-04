import 'package:formula_ticket_flutter/model/support/extensions/StringCapitalization.dart';
import 'package:flutter/material.dart';

import '../../../model/objects/Ticket.dart';
import '../../behaviors/AppLocalizations.dart';
import '../../../model/support/utils.dart';
import '../../widgets/InputField.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import 'chart_item_widget.dart';
import 'checkout_bottom_sheet.dart';


class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen>{
  bool _updating=false;

  void _remove(Ticket ticket) {
    setState(() => _updating=true);
    setState(() => {
      Utils.cart.remove(ticket),
      _updating=false
    }
    );
  }

  List<Ticket> _tickets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:AppText(
                  text: "Cart",
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),

              ),

            bottom(),
            getCheckoutButton(context),
          ],
        ),
      ),
    );

  }
  Widget bottom() {
        return  !_updating ?
        Utils.cart.isEmpty ?
    emptyCart():
    yesTicket():
    CircularProgressIndicator();
  }

  Widget yesTicket(){
    _tickets=[];
    Utils.cart.keys.forEach((key) {
      _tickets.add(key);
    });
   return Expanded(
       child:Container(
          child: ListView.builder(
            itemCount: _tickets.length,
            itemBuilder: (context, index) {
               return ChartItemWidget(
                ticket: _tickets[index],
                remove: _remove,
              );
            },
          ),
       )
       ,
    );
  }
  Widget emptyCart() {
      return AppText(text: "Cart empty",);
  }
  Widget getCheckoutButton(BuildContext context) {
    if (Utils.IS_LOGGED && Utils.cart.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: AppButton(
          label: "Go To Check Out",
          fontWeight: FontWeight.w600,
          padding: EdgeInsets.symmetric(vertical: 30),
          onPressed: () {
            showBottomSheet(context);
          },
        ),
      );
    }
    else{
      return Container();
    }
  }


  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CheckoutBottomSheet();
        });
  }

}