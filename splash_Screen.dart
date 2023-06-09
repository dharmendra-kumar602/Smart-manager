import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'package:smart_manager/login.dart';
import 'company.dart';
import 'time_off.dart';
class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}


class _splashScreenState extends State<splashScreen> {

  var get_company_name;
  var Token_Id;
  @override
  void initState() {
    super.initState();
    timerfunction();
  }



  timerfunction() async{
    SharedPreferences pref_company=await SharedPreferences.getInstance();
    get_company_name=pref_company.getString('preferenc_Company_name');
    Token_Id =pref_company.getString('token_id');

    if(get_company_name!=null){
      await Future.delayed(Duration(milliseconds: 1500),() {});

      if(Token_Id==null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard()));
      }


    }else{
      await Future.delayed(Duration(milliseconds: 1500),() {});
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Company()));
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(

      home: Scaffold(
        body: Column(
          children: [

            Container(
               height: 800,
              width: 400,
             child: Image.asset('assets/SplashScreen.png'),
            ),

          ],
        ),
      ),
    );
  }
}

