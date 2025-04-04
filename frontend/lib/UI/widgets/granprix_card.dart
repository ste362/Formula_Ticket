import 'package:formula_ticket_flutter/model/objects/GrandPrix.dart';
import 'package:formula_ticket_flutter/model/objects/Ticket.dart';
import 'package:formula_ticket_flutter/model/support/Constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../colors.dart';
import '../pages/TicketPage.dart';


class ProductCard extends StatelessWidget {
  final GrandPrix grandPrix;

  ProductCard(
      {Key key,
        this.grandPrix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(grandPrix.name+" "+ grandPrix.startDate.toString());
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),

        ),
        child: InkWell(
          splashColor: AppColors.primaryColor.withAlpha(30),
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            //debugPrint('Card tapped.');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => TicketPage(grandPrix: grandPrix)),
            );
          },

          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),

                    child: grandPrix.photo,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  Align(
                    alignment: Alignment.topLeft,
                    child:Text(
                      grandPrix.name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child:Text(
                      '${DateFormat("dd, MMM").format(grandPrix.startDate)} - ${DateFormat("dd, MMM").format(grandPrix.endDate)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:Text(
                    grandPrix.description.substring(0,Constants.MIN_DESCR_SIZE)+"...",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}



/*
return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),

      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child:Text(
                grandPrix.name,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
            child:Text(
              grandPrix.description,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            ),
          ],
        ),
      ),
    );
 */