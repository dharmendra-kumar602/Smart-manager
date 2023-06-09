import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
class ReimburseMent extends StatefulWidget {
  const ReimburseMent({Key? key}) : super(key: key);
  @override
  State<ReimburseMent> createState() => _ReimburseMent();

}

class _ReimburseMent extends State<ReimburseMent> {

  var leaveTypeId;
  var ApplyDate;
  var updated_at;
  var DaysIncluded;
  var TimeOffType;
  var LeaveType;
  var DescriptionProvided;
  var ApplyDateToStarting;
  var ApplyDateToEnding;
  var userNameValue;
  var timeData ;
  var myInt ;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Reimbursement',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
        leading: BackButton(color: Colors.black45),
      ),
      body:ExpansionTile(
        title: Text("This project is configure for new change in smartmanger"),
        trailing : Icon(Icons.add,color: Colors.red,size: 30,),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text('Status',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('APPROVED',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Apply Date:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                  Text('$ApplyDateToStarting'),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Dates:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                    Text('$ApplyDateToEnding'),

                  ],
                ),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Days Include:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                    Text('Apply Date'),

                  ],
                ),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Time Off Type:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                    Text('$TimeOffType'),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('Leave Type:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    Text('$TimeOffType'),
                  ],
                ),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Description Provided:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                    Text('$DescriptionProvided'),

                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}