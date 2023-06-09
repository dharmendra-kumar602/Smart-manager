import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
class LeaveData extends StatefulWidget {
  const LeaveData({Key? key}) : super(key: key);
  @override
  State<LeaveData> createState() => _LeaveData();

}

class _LeaveData extends State<LeaveData> {


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
    Pending_history();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
        itemCount:myInt,
        itemBuilder: (context, index) {
      return Card(
        child: ExpansionTile(
          title: Text("family Function $index"),
          trailing: Icon(Icons.add,color: Colors.red,size: 30,),
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Apply Date:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                      Text('$ApplyDateToStarting'),

                    ],
                  ),
                ), Padding(
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
    },),
    );
  }


  Pending_history() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
    userNameValue=prefs.getString('userIdName');
    var token = prefs.getString('token_id');
    var response = await http.get(Uri.parse(
    'https://uat.smartmanager.bel-technology.com/api/employeeleave?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&entityId=41&leaveStatus=PENDING'
    ),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
       timeData = jsondata['response'] as List;
      myInt = int.parse(timeData);
      for(var i=0;i<timeData.length;i++){
        setState(() {
          leaveTypeId=timeData[i]['leaveTypeId'];
          ApplyDate=timeData[i]['created_at'];
          var  formatted_In_Time = DateTime.parse(ApplyDate);
          ApplyDateToStarting=DateFormat("yyyy-MM-dd").format(formatted_In_Time);
          updated_at=timeData[i]['updated_at'];
          var  formatted_In_Time1 = DateTime.parse(updated_at);
          ApplyDateToEnding=DateFormat("yyyy-MM-dd").format(formatted_In_Time1);
          DaysIncluded=timeData[i]['maxCFCount'];
          TimeOffType=timeData[i]['leaveTypeCode'];
          LeaveType=timeData[i]['leaveTypeCode'];
          DescriptionProvided=timeData[i]['leaveDescription'];
          print(timeData[i]);
        });
      }
    }else{
      var jsondata = jsonDecode(response.body);
      Fluttertoast.showToast(msg: jsondata);
    }
  }



}