import 'package:flutter/material.dart';
import 'package:smart_manager/company.dart';
import 'package:smart_manager/dashboard.dart';
import 'package:smart_manager/splash_Screen.dart';
import 'Employee_Wise_Leave_Reports.dart';
import 'login.dart';
import 'time_off.dart';
import 'time_Off_History.dart';

void main() {
  runApp(
     // Company(),
      //LoginPage(),
      // DashBoard(),
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  // var size,height,width;

   @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    // height = size.height;
    // width = size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:splashScreen()
      , //DashBoard splashScreen() TimeOff(),TimeOffHistory
    );
  }
}


