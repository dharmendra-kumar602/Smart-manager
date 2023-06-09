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



class EmployeeLeave extends StatefulWidget {
  const EmployeeLeave({Key? key}) : super(key: key);

  @override
  State<EmployeeLeave> createState() => _EmployeeLeave();


}

class _EmployeeLeave extends State<EmployeeLeave> {


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
  var myInt;
  var DropDownSelected;
  var leaveTypeList;
  var fName;
  var lName;
  var employeeCode;
  var idname;
  var i;
  var totalDay;
  var ToDate;
  var userEntityId;


  var workingDays;
  var salaryDay;
  var totalLeave;
  var planLeave;
  var unPlanLeave;
  var paidLeave;
  var unPaid;
  var unApply;
  var namse;
  var timedata1;
  var _myemployee;
  var EntityId;
  var date;
  late String formattedDateDropdown;

  var selectedItem;
  var dropdownMonths;

  bool expensiontile=false;

  List employeeList=[];
  List<String> dates = [];


  @override
  void initState() {
    super.initState();
    //DropdownValueData();
   SalaryReport();
   getEmployeeList();
    Date();
  //  metadata();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Employee Wise Leave Reports',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
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
                          child: DropdownButtonFormField<
                              String>(
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
                                _myemployee = newValue;
                                EntityId=newValue;
                                userEntityId=EntityId;
                               print(userEntityId);
                              });
                            },
                            items:employeeList?.map((item) {
                              return DropdownMenuItem(
                                value: item['entityId']
                                    .toString(),
                                child:
                                Text("${item['fName']} ${item['lName']} (${item['employeeCode']})"),
                              );
                            })?.toList() ??
                                [],
                          ),
                        ),


                Container(
                  width: 380,
                  height: 50,
                  child:  DropdownButtonFormField<String>(
                    value: dates[0],
                    onChanged: (String? newValue) {
                      print(newValue);
                        var vals=newValue.toString();
                        var nas=vals.split(" ");
                        var indexMonth=nas[0];
                        var indexYear=nas[1];
                        switch(indexMonth){
                        case 'January': dropdownMonths=01;
                        break;
                        case 'February': dropdownMonths=02;
                        break;
                        case 'March': dropdownMonths=03;
                        break;
                        case 'April': dropdownMonths=04;
                        break;
                        case 'May': dropdownMonths=05;
                        break;
                        case 'June': dropdownMonths=06;
                        break;
                        case 'July': dropdownMonths=07;
                        break;
                        case 'August': dropdownMonths=08;
                        break;
                        case 'September': dropdownMonths=09;
                        break;
                        case 'October': dropdownMonths=10;
                        break;
                        case 'November': dropdownMonths=11;
                        break;
                        case 'December': dropdownMonths=12;
                        break;
                      }

                      var myIntYear1 = int.parse(indexYear.toString());
                         DateTime may2023 = DateTime(myIntYear1,dropdownMonths);
                           formattedDateDropdown = DateFormat('dd-MM-yyyy').format(may2023);
                         print('$formattedDateDropdown');

                    },
                    items: dates.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
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
                            DropdownValueData();
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
              child: expensiontile==true?
              ExpansionTile(
                      title: Text('$fName $lName',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
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
                                    child: Text('$fName $lName'),
                                  ),

                                ],
                              ),
                            ), Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('From Date:', style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: Text('$ApplyDate',),
                                  ),

                                ],
                              ),
                            ), Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('To Date:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: Text('$ToDate'),
                                  ),

                                ],
                              ),
                            ), Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Total Days:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 85),
                                    child: Text('$totalDay'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Working Days:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 60),
                                    child: Text('$workingDays'),
                                  ),
                                ],
                              ),
                            ), Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Salary Days:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70),
                                    child: Text('$salaryDay'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Total Leaves:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 65),
                                    child: Text('$totalLeave'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Plan Leaves:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70),
                                    child: Text('$planLeave'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Unplan Leaves:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 55),
                                    child: Text('$unPlanLeave'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Paid Leaves:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70),
                                    child: Text('$paidLeave'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('UnPaid Leaves:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text('$unPaid'),
                                  ),
                                ],
                              ),
                            ),Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('UnApply Leaves:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: Text('$unApply'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],

              ):null,
            ),

          ],
        ),
      )

    );
  }

  SalaryReport() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
   var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    var response = await http.post(Uri.parse('https://uat.smartmanager.bel-technology.com/api/getMonthlySalaryReport?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&csv=true&entityId=$UserEntityId&start=2023-04-01'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var timeData = jsondata['response'];
      var timeData1 = timeData['statusdate'];

    }else{
      var jsondata = jsonDecode(response.body);
      var erro=jsondata['message'];
      // Fluttertoast.showToast(msg:erro);
    }
  }

  DropdownValueData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
   var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    var response = await http.get(Uri.parse('https://uat.smartmanager.bel-technology.com/api/getMonthlySalaryReport?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&csv=true&entityId=$userEntityId&start=$formattedDateDropdown'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var timeData = jsondata['data'] as List;

      setState(() {
        expensiontile=true;
        for( i=0;i<timeData.length;i++)
        {
          timedata1=timeData[i]['employeeList'] as List;
        }
        for(var j=0;j<timedata1.length;j++){
          fName=timedata1[j]['fName'];
          lName=timedata1[j]['lName'];
          var created_at=timedata1[j]['created_at'];
          var  startDateTO=DateTime.parse(created_at.toString());
          ApplyDate = DateFormat("yyyy-MM-dd").format(startDateTO);
          var updated_at=timedata1[j]['updated_at'];
          var  startDateTO1=DateTime.parse(updated_at.toString());
          ToDate = DateFormat("yyyy-MM-dd").format(startDateTO1);
          totalDay=timedata1[j]['workDay'];
          namse=timedata1[j]['montlyLeaveInfo'];
          workingDays=namse['workingDays'];
          salaryDay=namse['paidDayCount'];
          totalLeave=namse['totalLeave'];
          planLeave=namse['planLeave'];
          unPlanLeave=namse['unPlanLeave'];
          paidLeave=namse['paidLeave'];
          unPaid=namse['unPaid'];
          unApply=namse['unApply'];
        }
      });
    }else{
      var jsondata = jsonDecode(response.body);
      var erro=jsondata['message'];
       Fluttertoast.showToast(msg:erro);
    }
  }

  DownLoadCsv() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
   var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    var response = await http.get(Uri.parse('https://uat.smartmanager.bel-technology.com/api/getMonthlySalaryReport?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&csv=true&entityId=41&start=2023-05-01'),
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
      setState(() {
        employeeList = jsonData['response'];
       // print(employeeList);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }
  }

  Date() {

      final currentDate = DateTime.now();
      final oneYearBack = currentDate.subtract(Duration(days: 365));

      final dateFormatter = DateFormat('MMMM yyyy');

      for (DateTime date = currentDate; date.isAfter(oneYearBack);
      date = date.subtract(Duration(days: 31))) {
        String formattedDate = dateFormatter.format(date);
        dates.add(formattedDate);
      }
      for (String date in dates) {
        print("tfhghhgfhgfhg$date");
      }

  }


    Future<File> generateCSV() async {
      List<List<dynamic>> rows = [
        ['Name', 'Age', 'Email'],
        ['John Doe', 30, 'johndoe@example.com'],
        ['Jane Smith', 25, 'janesmith@example.com'],
        // Add more rows as needed
      ];

      String csv = const ListToCsvConverter().convert(rows);

      // Get the document directory path
      String dir = (await getApplicationDocumentsDirectory()).path;
      // Create a File instance and write the CSV data to it
      File file = File('$dir/data.csv');
      await file.writeAsString(csv);

      return file;
    }


  List<List<dynamic>> generateCsvData() {
    // Your logic to generate the CSV data
    List<List<dynamic>> rows = [
      ['Name', 'Email', 'Phone'],
      ['John Doe', 'john@example.com', '1234567890'],
      ['Jane Smith', 'jane@example.com', '0987654321'],
    ];
    return rows;
  }

  // Future<void> downloadCsvFile() async {
  //   List<List<dynamic>> rows = generateCsvData();
  //   String csvData = const ListToCsvConverter().convert(rows);
  //
  //   final csvFileName = 'data.csv';
  //
  //   final downloadPath = await FlutterDownloader.getDownloadsDirectory();
  //   final savePath = '$downloadPath/$csvFileName';
  //
  //   await File(savePath).writeAsString(csvData);
  //
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: '',
  //     savedDir: downloadPath,
  //     fileName: csvFileName,
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  //}


  metadata(){
    List<String> myList = ['this ', 'moment of', 'show that is moment of'];

    Map<String, dynamic> queryParameters = {'values': myList};

    String url = Uri(
      scheme: 'https',
      host: 'www.example.com',
      path: '/endpoint',
      queryParameters: queryParameters,
    ).toString();

    print('this is url:$url');


  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



}
