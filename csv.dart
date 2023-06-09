import 'dart:convert';
import 'dart:io';

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



  List<List<dynamic>> convertToCsvData(List data) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Column(
  children: [
    FloatingActionButton(
      onPressed: () {
        List data = saveCsvFile(convertToCsvData as List<List>) as List; // Replace with your own data retrieval logic
        List<List<dynamic>> csvData = convertToCsvData(data);
        saveCsvFile(csvData);
      },
      child: Icon(Icons.file_download),
    ),


  ],
),

    );
  }

}