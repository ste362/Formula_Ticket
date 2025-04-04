

class Ticket {
  int id;
  String name;
  String type;
  DateTime validFrom;
  DateTime validUntil;
  double price;
  int qta;
  String session;
  String barCode;
  String description;


  Ticket({this.id, this.name,this.type, this.validFrom , this.validUntil,this.price,this.qta , this.session, this.barCode, this.description});

  factory Ticket.fromJson(Map<dynamic, dynamic> json) {
    return Ticket(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      validFrom : DateTime.parse(json['validFrom']).toLocal(),
      validUntil: DateTime.parse(json['validUntil']).toLocal(),
      price : json['price'],
      qta : json['qta'],
      session:json['session'],
      barCode: json['barCode'],
      description: json['descr'],
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type' : type,
    'validFrom' : validFrom.toIso8601String(),
    'validUntil': validUntil.toIso8601String(),
    'price':price,
    'qta':qta,
    'session':session,
    'barCode': barCode,
    'descr': description,
  };

  @override
  String toString() {
    return name;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Ticket &&
              barCode == other.barCode;

  @override
  int get hashCode => barCode.hashCode;
}