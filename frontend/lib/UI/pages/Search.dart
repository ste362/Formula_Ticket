import 'package:formula_ticket_flutter/UI/behaviors/AppLocalizations.dart';
import 'package:formula_ticket_flutter/UI/widgets/CircularIconButton.dart';
import 'package:formula_ticket_flutter/UI/widgets/InputField.dart';
import 'package:formula_ticket_flutter/UI/widgets/granprix_card.dart';
import 'package:formula_ticket_flutter/model/Model.dart';
import 'package:formula_ticket_flutter/model/objects/GrandPrix.dart';
import 'package:formula_ticket_flutter/model/objects/Ticket.dart';
import 'package:formula_ticket_flutter/model/support/extensions/StringCapitalization.dart';
import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text.dart';


class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);


  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _searching = false;
  List<GrandPrix> _grandprixs=[];

  TextEditingController _searchFiledController = TextEditingController();

  ScrollController _scrollController = ScrollController();
  int _page=0;
  bool isPerformingRequest = false;

  @override
  void initState() {

    super.initState();
    _getAll();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        //print("more data");
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            top(),
            bottom(),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Flexible(
            child: InputField(
              labelText: "search",
              controller: _searchFiledController,
              onSubmit: (value) {
                _search();
              },
            ),
          ),
          CircularIconButton(
            icon: Icons.search_rounded,
            onPressed: () {
              _search();
            },
          ),
        ],
      ),
    );
  }

  Widget bottom() {
    return  !_searching ?
              _grandprixs==null || _grandprixs.isEmpty?
                  noResults() :
                  yesResults():
              CircularProgressIndicator();
  }

  Widget noResults() {
    return Text("no_results");
  }

  Widget yesResults() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: _grandprixs.length,
          itemBuilder: (context, index) {
            if (index == _grandprixs.length) {
              return CircularProgressIndicator();
            } else {
              return ProductCard(
                grandPrix: _grandprixs[index],
              );
            }

          },
          controller: _scrollController,
        ),
      ),

    );
  }

  void _search() {
      setState(() {
        _searching = true;
        _grandprixs = null;
      });
      /* Model.sharedInstance.searchProduct(_searchFiledController.text).then((result) {
      setState(() {
        _searching = false;
        _tickets = result;
      });
    });

    */
      Model.sharedInstance.searchGrandPrix(_searchFiledController.text).then((result) {
        setState(() {
          _searching = false;
          _grandprixs = result;
        });
      });

  }

  void _getAll() {
    setState(() {
      _searching = true;
    });
      Model.sharedInstance.allGrandPrix(_page).then((result) {
        setState(() {
          _searching = false;
          _grandprixs.addAll(result);
        });
      });
  }
  _getMoreData() async {

    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<GrandPrix> newGrandPrixs = [];
      _page++;
      await Model.sharedInstance.allGrandPrix(_page).then((result) {
        //print(result);
        if(result!=null)
          newGrandPrixs=result;
      });//returns empty list

      if (newGrandPrixs.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge -offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }else {
        setState(() {
          _grandprixs.addAll(newGrandPrixs);
          isPerformingRequest = false;
        });
      }
    }
  }

}
