import 'dart:convert';
import 'pending_details.dart';
import 'archive_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


  class TimeOffHistory extends StatefulWidget {
  const TimeOffHistory({Key? key}) : super(key: key);
  @override
  State<TimeOffHistory> createState() =>_TimeOffHistory();


  }
  class _TimeOffHistory extends State<TimeOffHistory>{

    var leaveTypeId;
    var ApplyDate;
    var ApplayLastDate;
    var DaysIncluded;
    var TimeOffType;
    var LeaveType;
    var DescriptionProvided;
    var ApplyDateToStarting;
    var ApplyDateToEnding;
    var userNameValue;
    var myInt;
    var UserEntityIdValue;
    var  Title;
    var  leaveDaysCount;
    var myIntArchive;
    List timeData=[];
    List timeDataArchive=[];

    @override
  void initState() {
    super.initState();
    timeOff_history();
    ArchivedDate();
  }


  @override
  Widget build(BuildContext context) {

return MaterialApp(
  debugShowCheckedModeBanner: false,
  home: DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Time off History'),
    leading: BackButton(color: Colors.black45),
        backgroundColor: Colors.grey,
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.pending,size: 40,color: Colors.red,), text: 'Pending',
            ),
            Tab(icon: Icon(Icons.archive,size: 40,color: Colors.red,), text: "Archive")
          ],
        ),
      ),
      body: TabBarView(
        children: [
         // LeaveData(),
          tab1(),
          tab2(),
         // Archived(),
        ],
      ),
    ),
  ),
);
  }

  timeOff_history() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
     var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
      userNameValue=prefs.getString('userIdName');
      UserEntityIdValue=prefs.getString('UserEntityId');
      var token = prefs.getString('token_id');
      var response = await http.get(Uri.parse(
          'https://uat.smartmanager.bel-technology.com/api/employeeleave?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&entityId=$UserEntityIdValue&leaveStatus=PENDING'),
          headers: {'Authorization': 'Bearer $token'}
      );
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        timeData = jsondata['response'] as List;
        myInt = timeData.length;
        print(myInt);
        print(timeData);
        setState(() {
          for(var i=0;i<timeData.length;i++){
            myInt = timeData.length;
              leaveTypeId=timeData[i]['leaveTypeId'];
              Title=timeData[i]['title'];
              leaveDaysCount=timeData[i]['leaveDaysCount'];
              ApplyDate=timeData[i]['created_at'];
              var  formatted_In_Time1 = DateTime.parse(ApplyDate);
              ApplyDateToStarting=DateFormat("yyyy-MM-dd").format(formatted_In_Time1);
              ApplayLastDate=timeData[i]['updated_at'];
              var  formatted_In_Time2 = DateTime.parse(ApplayLastDate);
              ApplyDateToEnding=DateFormat("yyyy-MM-dd").format(formatted_In_Time2);
              TimeOffType=timeData[i]['typesOfLeave'];
              LeaveType=timeData[i]['leaveType'];
              DescriptionProvided=timeData[i]['application'];
          }
        });

      }else{
        var jsondata = jsonDecode(response.body);
        Fluttertoast.showToast(msg: jsondata);
      }
  }


    ArchivedDate() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
      userNameValue=prefs.getString('userIdName');
      UserEntityIdValue=prefs.getString('UserEntityId');
      var token = prefs.getString('token_id');
      var response = await http.get(Uri.parse(
          'https://uat.smartmanager.bel-technology.com/api/employeeleave?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&entityId=$UserEntityIdValue&perpage=15&pagination=true&page=1&leaveStatus=ARCHIVED'),
          headers: {'Authorization': 'Bearer $token'}
      );
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        var dataJsson=jsondata['response'];
        timeDataArchive = dataJsson['data'] as List;
        myIntArchive = timeDataArchive.length;
        print(myIntArchive);
        print(timeData);
        setState(() {
          for(var i=0;i<timeDataArchive.length;i++){
            myIntArchive = timeDataArchive.length;
           var leaveTypeIdArchived=timeDataArchive[i]['leaveTypeId'];
           var TitleAr=timeDataArchive[i]['title'];
           var  leaveDaysCountAr=timeDataArchive[i]['leaveDaysCount'];
          var  ApplyDate1=timeDataArchive[i]['created_at'];

          }
        });

      }else{
        var jsondata = jsonDecode(response.body);
        Fluttertoast.showToast(msg: jsondata);
      }
    }

  Widget tab1(){
    return ListView.builder(
        itemCount:myInt,
        itemBuilder: (BuildContext context,int index) {

            return Card(
              child: ExpansionTile(
                title: Text('${timeData[index]['title']}'),
                trailing: Icon(Icons.add, color: Colors.red, size: 30,),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Apply Date:', style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            Text('${
                                timeData[index]['applied_date']}'),

                          ],
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Dates:', style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            Text('${timeData[index]['todate']}'),
                          ],
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Days Include:', style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            Text('${timeData[index]['leaveDaysCount']}'),

                          ],
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Time Off Type:', style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            Text('${timeData[index]['typesOfLeave']}'),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('Leave Type:', style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),),
                            ),
                            Text('${timeData[index]['leaveType']}',
                                style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                          ],
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Description Provided:', style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            Text('${timeData[index]['application']}'),

                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
        // }
        },
    );
  }

    Widget tab2(){
      return
  Scaffold(
    body: ListView.builder(
      itemCount: myIntArchive,
      itemBuilder: ( BuildContext context,int index) {
        return Card(
          child: ExpansionTile(
            title: Text('${timeDataArchive[index]['title']}'),
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
                      Text('${timeDataArchive[index]['applied_date']}'),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Dates:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('${timeDataArchive[index]['todate']}'),

                      ],
                    ),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Days Include:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('${timeDataArchive[index]['leaveDaysCount']}'),

                      ],
                    ),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Time Off Type:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                        Text('${timeDataArchive[index]['leaveDescription']}'),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Leave Type:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                        ),
                        Text('${timeDataArchive[index]['typesOfLeave']}',style: TextStyle(color: Colors.black,fontSize: 10),),
                      ],
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Action Date:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('${timeDataArchive[index]['actionDate']}'),
                      ],
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Remark:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('${timeDataArchive[index]['remark']}'),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Description Provided:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('${timeDataArchive[index]['application']}'),

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

}