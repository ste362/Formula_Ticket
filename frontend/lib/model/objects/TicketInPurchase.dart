import 'package:formula_ticket_flutter/model/objects/Purchase.dart';

import 'Purchase.dart';
import 'Ticket.dart';

class TicketInPurchase {
  int id;
  int quantity;
  Purchase purchase;
  Ticket ticket;

  TicketInPurchase({this.id, this.quantity, this.purchase,this.ticket});

  factory TicketInPurchase.fromJson(Map<String, dynamic> json) {
    return TicketInPurchase(
        id: json['id'],
        //purchase: Purchase.fromJson(json['validFrom']),
        ticket: Ticket.fromJson(json['ticket']),
        quantity: json['quantity']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        //'purchase': purchase.toJson(),
        'ticket' :ticket.toJson(),
        'quantity':quantity

      };


}