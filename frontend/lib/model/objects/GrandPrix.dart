import 'dart:convert';

import 'package:flutter/material.dart';

class GrandPrix {
  int id;
  String name;
  String track;
  String description;
  Image photo;
  DateTime startDate;
  DateTime endDate;


  GrandPrix({this.id, this.name,this.track, this.description,this.photo,this.startDate,this.endDate});

  factory GrandPrix.fromJson(Map<dynamic, dynamic> json) {
    return GrandPrix(
      id: json['id'],
      name: json['name'],
      track: json['track'],
      description: json['descr'],
      photo: Image.memory((base64Decode(json['photo']))),
      startDate : DateTime.parse(json['startDate']).toLocal(),
      endDate: DateTime.parse(json['endDate']).toLocal(),
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'name': name,
    'track' : track,
    'descr': description,
    'startDate' : startDate,
    'endDate': endDate,
  };

  @override
  String toString() {
    return name +" "+track+" "+description;
  }


}