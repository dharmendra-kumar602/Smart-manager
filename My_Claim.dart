import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
class MyClaim extends StatefulWidget {
  const MyClaim({Key? key}) : super(key: key);
  @override
  State<MyClaim> createState() => _MyClaim();

}

class _MyClaim extends State<MyClaim> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Claim ' ,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
        leading: BackButton(color: Colors.black45),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 15,top: 10,right: 15),
                  child: Container(
                    width: 360,
                    height: 300,
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
                            Text('Testina Testina Testtina', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),

                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                            ),
                            Text('Unpaid'),
                          ],
                        ),
                        Row(
                          children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Claim Stage',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                           ),
                           Text('Pending'),
                          ],
                        ), Row(
                          children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Total Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                           ),
                           Text('710'),
                          ],
                        ), Row(
                          children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Aprove Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                           ),
                           Text('0'),
                          ],
                        ), Row(
                          children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Decription',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                           ),
                           Text('Decriptin something '),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 15,top: 10,right: 15),
                  child: Container(
                    width: 360,
                    height: 170,
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
                            Text('Aproved By:', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                            Text('No Data available'),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Level',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                            ),
                            Text('No Data available'),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Remarks',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
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
            ExpansionTile(
              title: Text("User  claim Data",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),

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
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Dates:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),

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
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Leave Type:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Description Provided:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}