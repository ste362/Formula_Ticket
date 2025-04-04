import 'package:formula_ticket_flutter/model/objects/Purchase.dart';
import 'package:formula_ticket_flutter/model/objects/TicketInPurchase.dart';

import '../objects/Ticket.dart';
import '../objects/User.dart';

class Utils{
  static final Map<Ticket,int> cart=Map();
  static bool IS_LOGGED=false;
/*
  static User user=User(
    id:5,
    firstName: "stefano",
    lastName: "iannicelli",
    telephoneNumber: "23",
    email: "bgb.alice.it",
    address: "via",
  );

 */
  static User user;

  static int countTickets(Purchase purchase) {
    if(purchase == null && purchase.ticketsInPurchase==null) return 0;
    int count=0;
    for(TicketInPurchase ticketInPurchase in purchase.ticketsInPurchase){
      count+=ticketInPurchase.quantity;
    }
    return count;
  }


  static double totalPrice() {
    double price=0;
    for(Ticket t in cart.keys){
      price+=cart[t]*t.price;
    }
    return price;
  }

  static getPrice(TicketInPurchase ticketInPurchase) {
      return ticketInPurchase.ticket.price * ticketInPurchase.quantity;
  }
  static getAllPrice(List<TicketInPurchase> ticketsInPurchase) {
    double total=0;
    for(TicketInPurchase ticketInPurchase in ticketsInPurchase){
      total+=getPrice(ticketInPurchase);
    }
    return total;
  }

}