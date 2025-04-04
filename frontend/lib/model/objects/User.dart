import 'package:formula_ticket_flutter/model/support/Constants.dart';

class User {
  int id;
  String code;
  String firstName;
  String lastName;
  String telephoneNumber;
  String email;
  String address;
  String password;


  User({this.id, this.code, this.firstName, this.lastName, this.telephoneNumber, this.email, this.address,this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      code: json['code'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      telephoneNumber: json['telephoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'firstName': firstName,
    'lastName': lastName,
    'telephoneNumber': telephoneNumber,
    'email': email,
    'address': address,
    'password': password,
  };

  @override
  String toString() {
    return firstName + " " + lastName;
  }

  static User mailExist() {
    return User(email: Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS);
  }


}