import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RecievedRequest.dart';


  class FinanceReceivedRequest extends StatefulWidget {
  const FinanceReceivedRequest({Key? key}) : super(key: key);

  @override
  State<FinanceReceivedRequest> createState() => _FinanceReceivedRequest();

  }
  class _FinanceReceivedRequest extends State<FinanceReceivedRequest> {

    List employeeList=[];
    List timeDataEmpleeList=[];
    List AlltimeDataEmpleeList=[];
    var Claim_Id;
    var id;
    @override
    void initState() {
      super.initState();

      AllgetEmployeeList();
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Finance Received Request ',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
        leading: BackButton(color: Colors.black45),

      ),
      body:
      SingleChildScrollView(
          child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 650,
                    width: 400,// Set a fixed height for the ListView
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: timeDataEmpleeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= 0 && index < timeDataEmpleeList.length) {
                            return Card(
                              child:
                              ExpansionTile(
                                title:InkWell(
                                  child: Text("${index}. ${timeDataEmpleeList[index]['fName'] } ${timeDataEmpleeList[index]['lName']} ${'('+timeDataEmpleeList[index]['employeeCode']})", style: TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  // trailing: Icon(Icons.add, color: Colors.red, size: 30,),

                                  onTap: () {

                                    setState(() async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();

                                      var val= timeDataEmpleeList[index]['claim_id'];
                                      prefs.setString('UserCliamId',val.toString());

                                      print('this is id:$val');
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) =>ReceivedRequest()));

                                    });
                                  },
                                ),

                                // Text("${index}. ${timeDataEmpleeList[index]['fName'] } ${timeDataEmpleeList[index]['lName']} ${'('+timeDataEmpleeList[index]['employeeCode']})", style: TextStyle(
                                //     color: Colors.black, fontWeight: FontWeight.bold,
                                //     fontSize: 15),),
                                // trailing: Icon(Icons.add, color: Colors.red, size: 30,),
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
                                              child: Text("${timeDataEmpleeList[index]['fName'] } ${timeDataEmpleeList[index]['lName']}",style: TextStyle(color: Colors.black),),
                                            ),//$fname $lname

                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text('Claim Title',
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 80),
                                              child: Text("${timeDataEmpleeList[index]['claim_title'] }"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
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
                                              padding: const EdgeInsets.only(left: 70),
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
                                              padding: const EdgeInsets.only(left: 30),
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
                        }
                    ),
                  ),
                ),

              ] )

      ),

    );

  }


  AllgetEmployeeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    var response = await http.get(
        Uri.parse('https://uat.smartmanager.bel-technology.com/api/getClaimRequest/1?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&perpage=10&pagination=true&page=1'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var jsondata=jsonData['response'];
      setState(() {
        timeDataEmpleeList = jsondata['data'] as List;

      });


    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }


  }


  }