import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';



class TimeOfByPersion extends StatefulWidget {
  const TimeOfByPersion({Key? key}) : super(key: key);

  @override
  State<TimeOfByPersion> createState() => _TimeOfByPersion();


}


class _TimeOfByPersion extends State<TimeOfByPersion> {

  TextEditingController FromDateController=new TextEditingController();
  TextEditingController ToDateController=new TextEditingController();

   var _myemployee;

  List employeeList=[];
  List timeDataEmpleeList=[];
  List AlltimeDataEmpleeList=[];
var IndexLength;

  var fname;
  var lname;
  var systemId;
  var FromDate;
  var ToDate;
  var count;
  var Title;
  var timeOff;
  var timeOffType;
  var Applied_Date;
  var DescriptionLeave;
  var StatringDate;
  var EndDate;

  //var student = new Map();
  String selectedValue = 'All';
  Map<String, String> student =
  {

    'fName': 'All',

  };

  // String selectedKey = 'fName';
  // String selectedValue = student[_myemployee];

  @override
  void initState() {
    super.initState();
   getEmployeeList();
    AllgetEmployeeList();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('time of by persion',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
          leading: BackButton(color: Colors.black45),

        ),
        body:
        SingleChildScrollView(
          child:Column(

            children: [
              Column(
                children: [
                  Container(
                    width: 380,
                    height: 50,
                    child: DropdownButtonFormField<String>(

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _myemployee,
                      iconSize: 20,
                      icon: (null),

                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hint: Text('Select Employee'),

                      onChanged: (String? newValue) {
                        print(newValue);
                        setState(() {
                          _myemployee = newValue!;
                         // student=newValue.toString() as Map<String, String>;

                        });
                      },
                      items:employeeList?.map((item) {
                        return DropdownMenuItem(
                          value: item['entityId'].toString(),
                          child:item['fName']=='All'? Text(  "${item['fName']}"):Text( "${item['fName']} ${item['lName']} (${item['employeeCode']})"),
                        );
                      })?.toList()??
                          [],
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,top: 10),
                        child: Container(
                        height: 30,
                        width: 160,
                        child:   ElevatedButton(onPressed:(){
                          setState(() {
                              FromDataPicker();
                                });

                         }, child: Text('From Date'),
                                 style: ElevatedButton.styleFrom(
                         primary: Colors.red, // Background color
                               ),
                               ),
                              ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30,top: 10),
                        child: Container(
                          height: 30,
                          width: 160,
                          child:   ElevatedButton(onPressed:(){
                            setState(() {
                              ToDataPicker();
                            });

                          }, child: Text('ToDate'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // Background color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20,top: 10),
                            child: Container(
                              height: 30,
                              width: 160,
                              child:   ElevatedButton(onPressed:(){
                                // filePicker();
                                setState(() {
                                  //DropdownValueData();
                                  listData();
                                  listData1();
                                    if(_myemployee=='null'){
                                      AllgetEmployeeList();
                                    }

                                });

                              }, child: Text('Filter'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Background color
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30,top: 10),
                            child: Container(
                              height: 30,
                              width: 160,
                              child:   ElevatedButton(onPressed:(){
                                setState(() {
                                  DownLoadCsv();
                                });
                              },
                                child: Text('Download CSV'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Background color
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 650,
                 width: 400,// Set a fixed height for the ListView
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: timeDataEmpleeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= 0 && index < timeDataEmpleeList.length)
                        return Card(
                        child:
                        ExpansionTile(
                          title: Text("${timeDataEmpleeList[index]['fName'] } ${timeDataEmpleeList[index]['lName']}", style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,
                              fontSize: 20),),
                          trailing: Icon(Icons.add, color: Colors.red, size: 30,),
                          children: [
                            Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Employee Name:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 40),
                                        child: Text("${timeDataEmpleeList[index]['fName'] } ${timeDataEmpleeList[index]['lName']}"),
                                      ),//$fname $lname

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('System Id',
                                        style: TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 80),
                                        child: Text("${timeDataEmpleeList[index]['userName'] }"),
                                      ),
                                    ],
                                  ),
                                ), Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('From Date:',
                                        style: TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 80),
                                        child:Text("${timeDataEmpleeList[index]['fromdate'] }"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('To Date:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 100),
                                        child: Text("${timeDataEmpleeList[index]['todate'] }"),
                                      ),
                                    ],
                                  ),
                                ), Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Count:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 85),
                                        child:Text("${timeDataEmpleeList[index]['leaveDaysCount'] }"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Title:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 60),
                                        child: Text("${timeDataEmpleeList[index]['title'] }"),
                                      ),

                                    ],
                                  ),
                                ), Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Time Off:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 70),
                                        child:Text("${timeDataEmpleeList[index]['leaveType'] }"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Time Off Type:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 65),
                                        child:Text("${timeDataEmpleeList[index]['leaveDescription'] }"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Applied Date:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 70),
                                        child: Text("${timeDataEmpleeList[index]['applied_date'] }"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Description:', style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 55),
                                        child:Text("${timeDataEmpleeList[index]['application'] }"),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            )
                          ],

                        ),
                      );
                    }
                        ),
                      ),
              ),

             ] )

          ),

    );
  }




  DownLoadCsv() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    var response = await http.get(Uri.parse('https://uat.smartmanager.bel-technology.com/api/getMonthlySalaryReport?institution_Id=$institution_setPrefrence__Id&channel=APP&csv=true&entityId=41&start=2023-05-01'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var timeData = jsondata['response'] as List;
      Fluttertoast.showToast(msg:'downloads successfully');

    }else{
      var jsondata = jsonDecode(response.body);
      var erro=jsondata['message'];
      Fluttertoast.showToast(msg:erro);
    }
  }



  getEmployeeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
    var response = await http.get(
        Uri.parse('https://uat.smartmanager.bel-technology.com/api/getEmployeeByRoleOrder?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&status=1'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      employeeList = jsonData['response'] as List;


     // var student = new Map();

      student['fName'] = 'All';
      // student['lName'] = '';
      // student['employeeCode'] = '';

      setState(() {
        employeeList.insert(0, student);

        employeeList;
       print(employeeList);
      });
      setState(() {
        employeeList;
      });
     // print(employeeList);

    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }
  }

  AllgetEmployeeList() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token_id');
      var  UserEntityId =prefs.getString('UserEntityId');
      var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
      var response = await http.get(
          Uri.parse('https://uat.smartmanager.bel-technology.com/api/getTimeOffByPerson?institution_Id=$institution_setPrefrence__Id&channel=APP'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
         timeDataEmpleeList = jsonData['response'] as List;
        if(timeDataEmpleeList==null){
          Fluttertoast.showToast(
            msg: 'Data Not Available',
            backgroundColor: Colors.grey,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Error',
          backgroundColor: Colors.grey,
        );
      }


  }

  FromDataPicker()
  {
    showDatePicker(context:  context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025)
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          FromDateController.text=selectedDate.toString();
         var  startDateTO=DateTime.parse(selectedDate.toString());
           StatringDate = DateFormat("yyyy-MM-dd").format(startDateTO);
         print(StatringDate);
        });
      }
    }
    );
  }

  ToDataPicker() {
    showDatePicker(context: context,
        initialDate: DateTime.now(), // DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025)
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          ToDateController.text = selectedDate.toString();
          ToDate = selectedDate;
           EndDate = DateFormat("yyyy-MM-dd").format(ToDate);
          print(EndDate);

        });
      }
    }
    );
  }

  listData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var UserEntityId = prefs.getString('UserEntityId');
    var institution_setPrefrence__Id = prefs.getString(
        'institution_Id_setPrefrence');
    var response = await http.get(
        Uri.parse(
            'https://uat.smartmanager.bel-technology.com/api/getTimeOffByPerson?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&perpage=10&pagination=true&page=1&employeeId=$_myemployee'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var dataresponse = jsonData['response'];
      timeDataEmpleeList = dataresponse['data'] as List;
    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }
  }
    listData1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
    var response = await http.get(
        Uri.parse('https://uat.smartmanager.bel-technology.com/api/getTimeOffByPerson?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&perpage=10&pagination=true&page=1&employeeId=$_myemployee&startDate=$StatringDate&endDate=$EndDate'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var dataresponse=jsonData['response'];
       timeDataEmpleeList = dataresponse['data'] as List;

       if(timeDataEmpleeList==null){
         Fluttertoast.showToast(
           msg: 'Data Not Available',
           backgroundColor: Colors.grey,
         );
       }
    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }

  }




}
