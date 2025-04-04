import 'dart:async';
import 'dart:convert';
import 'package:formula_ticket_flutter/model/managers/RestManager.dart';
import 'package:formula_ticket_flutter/model/objects/AuthenticationData.dart';
import 'package:formula_ticket_flutter/model/objects/GrandPrix.dart';
import 'package:formula_ticket_flutter/model/objects/Ticket.dart';
import 'package:formula_ticket_flutter/model/objects/User.dart';
import 'package:formula_ticket_flutter/model/support/Constants.dart';
import 'package:formula_ticket_flutter/model/support/LogInResult.dart';
import 'package:formula_ticket_flutter/model/support/exceptions/exceptions.dart';
import 'package:formula_ticket_flutter/model/support/utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'objects/Purchase.dart';

class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();
  AuthenticationData _authenticationData;


  Future<LogInResult> logIn(String email, String password) async {
    try{
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      //params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData.hasError() ) {
        if ( _authenticationData.error == "Invalid user credentials" ) {
          return LogInResult.error_wrong_credentials;
        }
        else if ( _authenticationData.error == "Account is not fully set up" ) {
          return LogInResult.error_not_fully_setupped;
        }
        else {
          return LogInResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData.expiresIn - 50)), (Timer t) {
        _refreshToken();
      });
      return LogInResult.logged;
    }
    catch (e) {
      return LogInResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData.hasError() ) {
        return false;
      }
      _restManager.token = _authenticationData.accessToken;
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<List<Ticket>> searchTicket(DateTime startDate,DateTime endDate,int grandPrixID,String type) async {
    Map<String, String> params = Map();
    //print(DateFormat("dd-MM-yyyy").format(startDate));
    params["startDate"] = DateFormat("yyyy-MM-dd").format(startDate);
    params["endDate"] = DateFormat("yyyy-MM-dd").format(endDate);
    params["grandPrixID"] = grandPrixID.toString();
    params["type"] = type;
    try {
      return List<Ticket>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_TICKETS, params)).map((i) => Ticket.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<GrandPrix>> allGrandPrix(int pageNumber) async {
    Map<String, String> params = Map();
    params["pageNumber"] =pageNumber.toString();
    try {
      return List<GrandPrix>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ALL_GRANDPRIX,params)).map((i) => GrandPrix.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<GrandPrix>> searchGrandPrix(String name) async {
    Map<String, String> params = Map();
    params["grandPrixName"] = name;
    try {
      return List<GrandPrix>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_GRANDPRIX,params)).map((i) => GrandPrix.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<User> addUser(User user) async {
    String rawResult;
    try {
       rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_USER, user);
      return User.fromJson(jsonDecode(rawResult));

    }
    catch (e) {
      if ( rawResult.contains(Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
        throw new MailAlreadyExistsException();
      }
      return null; // not the best solution
    }
  }

  Future<Purchase> addPurchase(Purchase purchase) async {
    try {
      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_PURCHASE, purchase);
      if ( rawResult.contains(Constants.RESPONSE_ERROR_QUANTITY_UNAVAILABLE) ) {
        throw new ProductQuantityUnavailableException(); // not the best solution
      }
      else {
        //print(rawResult);
        return Purchase.fromJson(jsonDecode(rawResult));
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }


  Future<List<Purchase>> getPurchases() async {
    try {
      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_PURCHASES, Utils.user);
      if ( rawResult.contains(Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
        throw new MailAlreadyExistsException();
      }
      else {
        return List<Purchase>.from(json.decode(rawResult).map((i) => Purchase.fromJson(i)).toList());;
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<User> getUser() async {
    try {
      String rawResult = await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_GET_USER);
      if ( rawResult.contains(Constants.ERROR_SAME_EMAIL) ) {
        throw new MailAlreadyExistsException();
      }
      else {
        return User.fromJson(jsonDecode(rawResult));
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }


}
