import 'dart:convert';
import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;



import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';


 class csv extends StatefulWidget {
  const csv({Key? key}) : super(key: key);
  @override
  State<csv> createState() => _csv();
}

class _csv extends State<csv> {


  List<List<dynamic>> convertToCsvData(List  data) {
    List<List<dynamic>> csvData = [];


    // Add header row
    csvData.add(['Name', 'Age', 'Email']);

    // Add data rows
    data.forEach((item) {
      csvData.add([item.name, item.age, item.email]);
    });

    return csvData;
  }


  Future<void> saveCsvFile(List<List> csvData) async {
    String csvFileName = 'data.csv';

    //List<List<dynamic>> csvData
    // Get the document directory path
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;

    // Create the file
    File file = File('$path/$csvFileName');

    // Convert CSV data to a string
    String csvContent = const ListToCsvConverter().convert(csvData);

    // Write to file
    await file.writeAsString(csvContent);

    // Show a snackbar or display a message indicating the file is saved
    // For example, using ScaffoldMessenger:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV file saved: $csvFileName')),
    );
  }

  @override
  void initState() {
    super.initState();
    demo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Center(

              child: FloatingActionButton(
                onPressed: () {
                 List data = saveCsvFile as List;
                 List<List<dynamic>> csvData = convertToCsvData(data);
                 saveCsvFile(csvData);

                },
                child: Icon(Icons.file_download),
              ),
            ),
          ),



          // FlatButton(
          //   child: Text('Download CSV'),
          //   onPressed: () {
          //     downloadCSVFile();
          //   },
          // ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('downloads '),
              onPressed: (){
                setState(() {
                  downloadCSVFile();
                });
              },
            ),
          ),
        ],
      ),

    );
  }

  Future<void> downloadCSVFile() async {
    // File URL
    String url = 'https://example.com/path/to/your/file.csv';

    // Send HTTP GET request
    var response = await http.get(Uri.parse(url));

    // Get the temporary directory path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Save the file
    File file = File('$appDocPath/file.csv');
    await file.writeAsBytes(response.bodyBytes);


    // Show a dialog or perform any action after the file is downloaded
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Download Complete'),
        content: Text('The CSV file has been downloaded.'),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }


  demo(){

    List name=[];
    List name1=[1,3,4,5,7];
    for(var i=0;i<name1.length;i++){
      name.add(name1[i]);
      name.addAll([2,34,6]);
      name.insert(2,4);
      name.insertAll(2,[1,2,3]);
    }

    for(var j=0;j<name.length;j++){
      print(name[j]);
    }

    Set<String> emp={'this','that','these'};
    Set<int> emp1={1,3,2,4,6};
    var s=emp.length;
    print(s);


    Map namess={
  'name':'lol',
  'name':'lol',
  'name':'lol',
  'name':'lol',

};
var n=namess.length;
print(n);


  }

}









/* Scaffold(
      appBar: AppBar(
        title: Text('Finance Received Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
           color: Colors.grey,
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
                                  Text('Claim title',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: Text("${timeDataEmpleeList[index]['claim_title'] }"),
                                  ),
                                ],
                              ),
                            ), Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Claim Stage:',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child:Text("${timeDataEmpleeList[index]['claim_stage'] }"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Claim Status:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: Text("${timeDataEmpleeList[index]['status'] }"),
                                  ),
                                ],
                              ),
                            ), Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Total Claim Amount:', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 85),
                                    child:Text("${timeDataEmpleeList[index]['claimAmt'] }"),
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
      ), ),
    );*/



