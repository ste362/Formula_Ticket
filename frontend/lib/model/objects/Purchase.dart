import 'dart:convert';

import 'package:formula_ticket_flutter/model/support/Constants.dart';

import 'TicketInPurchase.dart';
import 'User.dart';

class Purchase {
  int id;
  DateTime purchaseTime;
  User user;
  List<TicketInPurchase> ticketsInPurchase;
  double price;

  Purchase({this.id, this.purchaseTime, this.user,  this.ticketsInPurchase,this.price});

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      purchaseTime : DateTime.parse(json['purchaseTime']).toLocal(),
      user: User.fromJson(json['buyer']),
      ticketsInPurchase: List<TicketInPurchase>.from(json['ticketsInPurchase'].map((i) => TicketInPurchase.fromJson(i)).toList()),
      price: json['price']
    );
  }

  Map<String, dynamic> toJson() => {
    'buyer': user.toJson(),
    'purchaseTime' : purchaseTime.toIso8601String(),
    'ticketsInPurchase': List<dynamic>.from(ticketsInPurchase.map((x) => x.toJson())),
    'price': price
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Purchase &&
               user.email==other.user.email;
  @override
  String toString() {
    return "id: "+this.id.toString()+" user:"+this.user.toString()+" purchaseTime:"+this.purchaseTime.toString();
  }
}