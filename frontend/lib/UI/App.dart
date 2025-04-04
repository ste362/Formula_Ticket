import 'package:formula_ticket_flutter/UI/behaviors/AppLocalizations.dart';
import 'package:formula_ticket_flutter/UI/pages/dashboard/dashboard_screen.dart';
import 'package:formula_ticket_flutter/model/support/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,

      theme: ThemeData(

        primarySwatch:Colors.red,
        primaryColor: Color(0xffee0022),
        backgroundColor: Colors.white,
        buttonColor: Colors.red,
      ),

      home: DashboardScreen(index:0),
    );
  }


}
