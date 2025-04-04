import 'package:formula_ticket_flutter/UI/widgets/CounterView.dart';
import 'package:formula_ticket_flutter/UI/widgets/LabeledCheckbox.dart';
import 'package:formula_ticket_flutter/UI/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/Model.dart';
import '../../model/objects/GrandPrix.dart';
import '../../model/objects/Ticket.dart';
import '../widgets/app_text.dart';
import '../widgets/ticket_dialog.dart';

class TicketPage extends StatefulWidget {
  final GrandPrix grandPrix;

  const TicketPage({Key key,
    this.grandPrix}) :
        super(key: key);


  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {

  bool _lawn = true,
      _grandstand = false,
      _paddok = false;
  int counter = 0;

  DateTime _startDate;
  DateTime _endDate;
  String _checkAvailability;
  Ticket _ticket;

  bool _checkingAvailability = true;
  RangeValues _currentRangeValues;

  int _maxRange;
  
  void initState() {
    _startDate = widget.grandPrix.startDate;
    _endDate = this.widget.grandPrix.endDate;
    _maxRange=2;
    _currentRangeValues = RangeValues(0, _maxRange.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

          title: Text("Ticket: " + this.widget.grandPrix.name,
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          centerTitle: true,

        ),

        body: LayoutBuilder(
            builder: (context, costraints) =>
                SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: costraints.maxHeight
                        ),
                        child: IntrinsicHeight(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [

                                  Padding(padding: const EdgeInsets.only(left: 10, bottom: 10,right: 10),
                                    child: Column(
                                      children:<Widget>[
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: this.widget.grandPrix.photo,

                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        AppText(
                                        text: "GrandPrix descriptions: \n" +this.widget.grandPrix.description,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff7C7C7C),
                                        textAlign:TextAlign.start,
                                      ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      AppText(
                                        text: "Select date",
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        textAlign:TextAlign.left,
                                      ),
                                      getTimeDateUI(),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Select type",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        LabeledCheckbox(label: "Lawn",
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            value: _lawn,
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                if(newValue || _paddok || _grandstand)
                                                      _lawn = newValue;
                                                _paddok = false;
                                                _grandstand = false;
                                              });
                                            }
                                        ),
                                        LabeledCheckbox(label: "Grandstand",
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            value: _grandstand,
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                if(newValue || _paddok || _lawn)
                                                    _grandstand = newValue;
                                                _paddok = false;
                                                _lawn = false;
                                              });
                                            }
                                        ),
                                        LabeledCheckbox(label: "Paddok Pass",
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            value: _paddok,
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                if(newValue || _lawn || _grandstand)
                                                    _paddok = newValue;
                                                _lawn = false;
                                                _grandstand = false;
                                              });
                                            }
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        AppButton(
                                          label: "Check availability",
                                          onPressed: () {
                                            _checkTicket();
                                          },
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                      ]
                                    )
                                    ,),




                                ]
                            )
                        )
                    )
                )
        )
    );
  }

  Widget addToCart() {
    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10,),
      child: Column(

      ),
    );
  }


  void _checkTicket() {
    setState(() {
      _checkingAvailability = true;
      if (_startDate == null) {
        _startDate = this.widget.grandPrix.startDate;
        _endDate = this.widget.grandPrix.endDate;
      }
      _ticket = null;
    });
    String type="";
    if(_lawn) type="lawn";
    else if(_grandstand) type="grandstand";
    else type="paddok";
    Model.sharedInstance.searchTicket(
        _startDate, _endDate, this.widget.grandPrix.id,type).then((result) {
      setState(() {
        _checkingAvailability = false;
        //print(result);

        if(result==null){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return TicketNotAvailable();
              });
        }
        else {
          _ticket = result.first;
          //
          // print("the ticket was" + _ticket.toString());

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return TicketAvailable(ticket: _ticket);
              });
        }
      });
    });
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[



          const SizedBox(
            height: 30,
          ),
          RangeSlider(
            values: _currentRangeValues,
            max: _maxRange.toDouble(),
            divisions: _maxRange,

            labels: RangeLabels(
              DateFormat('EEE, dd MMM').format(_startDate),
              DateFormat('EEE, dd MMM').format(_endDate),
            ),

            onChanged: (RangeValues values) {
              setState(() {
                if(values.start>_currentRangeValues.start){
                  //print(_startDate);
                  _startDate=_startDate.add(Duration(days:1 ));
                  //print(_startDate);
                }
                if(values.start<_currentRangeValues.start){
                  _startDate=_startDate.subtract(Duration(days:1 ));
                }
                if(values.end>_currentRangeValues.end){
                  _endDate=_endDate.add(Duration(days:1 ));
                }
                if(values.end<_currentRangeValues.end){
                  _endDate=_endDate.subtract(Duration(days:1 ));
                }
                _currentRangeValues = values;

              });
            },
          ),
          const Divider(
            height: 2,
          ),
          Row(
          children: <Widget>[
          Expanded(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: <Widget>[

              Text(
                'From',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color:
                    Colors.grey.withOpacity(0.8)),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                _startDate != null
                    ? DateFormat('EEE, dd MMM')
                    .format(_startDate)
                    : '--/-- ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
            Container(
            height: 74,
            width: 1,
            color: ThemeData.light().dividerColor,
            ),
            Expanded(
             child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: <Widget>[

                Text(
                'To',
                style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 16,
                color:
                Colors.grey.withOpacity(0.8)),
                ),
                  const SizedBox(
                  height: 4,
                  ),
                  Text(
                  _endDate != null
                  ? DateFormat('EEE, dd MMM')
                      .format(_endDate)
                      : '--/-- ',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
             ),
            ],
            ),
            )
            ],
            ),
            const Divider(
            height: 2,
            ),





        ]

    )
    );
  }


}


