import 'dart:ui';

import 'package:formula_ticket_flutter/UI/colors.dart';
import 'package:formula_ticket_flutter/UI/pages/account/purchaseWidget.dart';
import 'package:formula_ticket_flutter/model/objects/Purchase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/Model.dart';
import '../../Login/login_screen.dart';
import '../../../model/support/utils.dart';
import '../../widgets/app_text.dart';
import '../dashboard/dashboard_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _searching = false;
  List<Purchase> _purchases;
  @override
  void initState(){
    setState(() {
      if(Utils.IS_LOGGED)
        _search();
    });
}

  @override
  Widget build(BuildContext context) {

    return !Utils.IS_LOGGED ?
    LoginPage() :
    yesLogged();
  }

  yesLogged() {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              ListTile(
                  title: AppText(
                  text: "Account Page",
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),

              ),
              AppText(
                text: Utils.user.firstName+" "+Utils.user.lastName,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              AppText(
                text: Utils.user.email,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),

              SizedBox(
                height: 20,
              ),

              logoutButton(context),
              SizedBox(
                height: 20,
              ),
              AppText(
                text: "Order History",
                fontSize: 22,
                fontWeight: FontWeight.normal,
              ),
               orderHistory(),
            ],
          ),

      ),
    );

  }

  Widget orderHistory() {

    return  !_searching ?
    _purchases == null ?
    noResults() :
    yesResults():
    CircularProgressIndicator();
  }

  void _search() {
    setState(() {
      _searching = true;
      _purchases = null;
    });

    Model.sharedInstance.getPurchases().then((result) {
      setState(() {
        _searching = false;
        _purchases = result;
      });
    });

  }

  Widget noResults() {
    return Text("no order");
  }

  Widget yesResults() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: _purchases.length,
          itemBuilder: (context, index) {
            return PurchaseCard(
              purchase: _purchases[index],
              index: index+1,
            );
          },
        ),
      ),
    );
  }
}


Widget logoutButton(context) {
  return Container(
    width: double.maxFinite,
    margin: EdgeInsets.symmetric(horizontal: 25),
    child: RaisedButton(
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: Color(0xffF2F3F2),
      textColor: Colors.white,
      elevation: 0.0,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              "icons/account_icons/logout_icon.svg",
              color: AppColors.primaryColor,
            ),
          ),
          Text(
            "Log Out",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          Container()
        ],
      ),
      onPressed: () {
        Model.sharedInstance.logOut().then((value)  {
          if(value){
            print("Correttamnte sloggato");
            Utils.IS_LOGGED=false;
            Utils.user=null;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DashboardScreen(index: 0)),
                  (route) => false,
            );
          }
          else{
            print("Errore");
          }
        });
      },
    ),
  );
}
