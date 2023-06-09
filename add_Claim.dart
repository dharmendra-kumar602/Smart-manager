import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
class AddClaim extends StatefulWidget {
  const AddClaim({Key? key}) : super(key: key);
  @override
  State<AddClaim> createState() => _AddClaim();
}


class _AddClaim extends State<AddClaim> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Profile',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
        leading: BackButton(color: Colors.black45),
      ),
      body:
      SingleChildScrollView(
      child:Column(
        children: [
          ExpansionTile(
            title: Text("MyClaim"),
            trailing: Icon(Icons.add, color: Colors.red, size: 30,),
            children: [
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Container(
                      width: 360,
                      height: 350,
                      padding:  EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0)),
                          color: Colors.white),
                      // child://Text('Attendance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Sr.No:', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              Text('No Data available'),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Claim No:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              ),
                              Text('No Data available'),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Claim Title',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              ),
                              Text('No Data available'),
                            ],
                          ),Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Claim Stage',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              ),
                              Text('No Data available'),
                            ],
                          ),Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Claim Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              ),
                              Text('No Data available'),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Total Claim Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              ),
                              Text('No Data available'),
                            ],
                          ), Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Appove Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              ),
                              Text('No Data available'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Container(
            height: 800,
            width: 400,
            child: Image.asset('assets/empty-claim.png'),
          ),
        ],
      ),
    ),
    );
  }
}