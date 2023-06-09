import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class  ReceivedRequest extends StatefulWidget {
  const ReceivedRequest({Key? key}) : super(key: key);

  @override
  State<ReceivedRequest> createState() => _ReceivedRequest();

}
class _ReceivedRequest extends State<ReceivedRequest> {

  var Sr_No;
  var Bill_No;
  var Title;
  var Status;
  var TotalClaim_amount;
  var claimApproveAmt;
  var Claim_stage;
  var total;

  List employeeList=[];
  List timeDataEmpleeList=[];
  List ApprovedDataEmpleeList=[];
  List AlltimeDataEmpleeList=[];


  String dropdownvalue = 'Reject';

  TextEditingController ControllerDecription=new TextEditingController();
  var items = [
    'Reject',
    'Need More Details',

  ];

  @override
  void initState() {
    super.initState();
    AllgetEmployeeList();
    ApproveData();
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
         child:
         Column(
           children: [
             Padding(
               padding:  EdgeInsets.only(left: 15,top: 10,right: 15),
               child:
               ListView.builder(
                   shrinkWrap: true,
                   itemCount: timeDataEmpleeList.length,
                   itemBuilder: (BuildContext context, int index) {
                     if (index >= 0 && index < timeDataEmpleeList.length){
                       return
               Container(
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
                 child:

              Column(
                   children: [
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 10),
                           child: Text('Sr.No:', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(left: 20),
                           child: Text('${timeDataEmpleeList[index]['claim_mapping_id'] }'),
                         ),
                       ],
                     ),
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Claim No:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${timeDataEmpleeList[index]['bill_no'] }'),
                       ],
                     ),
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Claim Title',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${timeDataEmpleeList[index]['title'] }'),
                       ],
                     ),
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Claim Stage',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${timeDataEmpleeList[index]['status'] }'),
                       ],
                     ),
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Claim Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${timeDataEmpleeList[index]['status'] }'),
                       ],
                     ),
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Total Claim Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${timeDataEmpleeList[index]['amount'] }'),
                       ],
                     ),

                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Appove Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${timeDataEmpleeList[index]['amount'] }'),
                       ],
                     ),

                     // Row(
                     //   children: [
                     //     Padding(
                     //       padding: const EdgeInsets.all(8.0),
                     //       child: Text('Total:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                     //     ),
                     //     Text('$total'),
                     //   ],
                     // ),

                   ],
                 )

                );}}
               ),
             ),

               ListView.builder(
               shrinkWrap: true,
               itemCount: ApprovedDataEmpleeList.length,
                   itemBuilder: (BuildContext context, int index) {
              if (index >= 0 && index < ApprovedDataEmpleeList.length){
              return
             Padding(
               padding: const EdgeInsets.only(top: 10),
               child: Container(
                 width: 300,
                 height: 250,
                 padding:  EdgeInsets.only(left: 10,right: 10),
                 decoration: BoxDecoration(
                     border: Border.all(color: Colors.black),
                     borderRadius: BorderRadius.only(
                         topRight: Radius.circular(40.0),
                         topLeft: Radius.circular(40.0),
                         bottomRight: Radius.circular(40.0),
                         bottomLeft: Radius.circular(40.0)),
                     color: Colors.white),
                 child:
                 Column(
                   children:[
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Approved By',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${ApprovedDataEmpleeList[index]['fName']} ${ApprovedDataEmpleeList[index]['lName']}'),
                       ],
                     ),
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Level',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${ApprovedDataEmpleeList[index]['level']}'),
                       ],
                     ),Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Remark',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                         ),
                         Text('${ApprovedDataEmpleeList[index]['remark']}'),
                       ],
                     ),

                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                     primary: Colors.red),
                               onPressed: (){


                               },

                               child: Text('Approved')
                           ),
                         ),

                         Padding(
                           padding: const EdgeInsets.only(left: 0),
                           child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                   primary: Colors.red),
                               onPressed: () {
                                 showDialog(
                                   context: context,
                                   builder: (BuildContext context) {
                                     return AlertDialog(
                                       title: Text('Reject Claim',style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                       content: Container(
                                         height: 200,
                                         width: 200,
                                         child: Column(
                                           children: [
                                             Padding(
                                               padding: const EdgeInsets.only(right: 160),
                                               child: Text('Reason*',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
                                             ),

                                             DropdownButtonFormField(

                                               // Initial Value
                                               value: dropdownvalue,

                                               // Down Arrow Icon
                                               icon: const Icon(Icons.keyboard_arrow_down),

                                               // Array list of items
                                               items: items.map((String items) {
                                                 return DropdownMenuItem(
                                                   value: items,
                                                   child: Text(items),
                                                 );
                                               }).toList(),
                                               // After selecting the desired option,it will
                                               // change button value to selected value
                                               onChanged: (String? newValue) {
                                                 setState(() {
                                                   dropdownvalue = newValue!;
                                                 });
                                               },
                                             ),
                                             Padding(
                                               padding: const EdgeInsets.only(right: 160),
                                               child: Text('Remark*',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
                                             ),
                                             TextFormField(
                                               controller: ControllerDecription,
                                               autofocus: false,
                                               decoration: InputDecoration(
                                                 hintText: 'Description',
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                       actions: <Widget>[
                                         TextButton(
                                           child: Text('Cancel'),
                                           onPressed: () {
                                             Navigator.of(context).pop();
                                           },
                                         ),
                                         TextButton(
                                           child: Text('Submit'),
                                           onPressed: () {
                                             setState(() {
                                               RejectData();
                                             });
                                             Navigator.of(context).pop();
                                           },
                                         ),
                                       ],
                                     );
                                   },
                                 );


                               },
                               child: Text('Reject')
                           ),
                         ),


                       ],
                     )
                   ],
                 ),
               ),
             );};})
           ],
         ),

      ),

    );
  }

  AllgetEmployeeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var userClaim_Id=prefs.getString('UserCliamId');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
    var response = await http.get(
        Uri.parse('https://uat.smartmanager.bel-technology.com/api/editClaim/$userClaim_Id?institution_Id=$institution_setPrefrence__Id&channel=BROWSER'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var jsondata=jsonData['response'];
      timeDataEmpleeList=jsondata['claimDetailInfo'] as List;
      setState(() {
        if(timeDataEmpleeList==null){
          Fluttertoast.showToast(
            msg: 'Data Not Available',
            backgroundColor: Colors.grey,
          );
        }
      });

    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }
  }


  RejectData() async{


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var userClaim_Id=prefs.getString('UserCliamId');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    Map userDatails={
      'claim_id':userClaim_Id.toString(),
      'entity_id':UserEntityId.toString(),
      'claim_approve_by_entity_id':'1',
      'isApprove':'1',
      'remark':ControllerDecription.text.toString(),
      'reason':dropdownvalue.toString(),
    };
    var response = await http.post(
        Uri.parse('https://uat.smartmanager.bel-technology.com/api/claimApprove?institution_Id=$institution_setPrefrence__Id&channel=BROWSER'),
        headers: {'Authorization': 'Bearer $token'},body:userDatails);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var jsondata=jsonData['response'];
      //timeDataEmpleeList=jsondata['claimDetailInfo'] as List;

      Fluttertoast.showToast(
        msg: 'Successfully run api reject',
        backgroundColor: Colors.grey,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }

  }


  ApproveData() async{
    //https://uat.smartmanager.bel-technology.com/api/getApproveClaimEmpList/46?institution_Id=1001&channel=BROWSER

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var userClaim_Id1=prefs.getString('UserCliamId');
    var  UserEntityId =prefs.getString('UserEntityId');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
    var response = await http.get(
        Uri.parse('https://uat.smartmanager.bel-technology.com/api/getApproveClaimEmpList/$userClaim_Id1?institution_Id=$institution_setPrefrence__Id&channel=BROWSER'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
       ApprovedDataEmpleeList=jsonData['response']  as List;
       for(var i=0;i<ApprovedDataEmpleeList.length;i++){

       }
      Fluttertoast.showToast(
        msg: 'Successfully run api',
        backgroundColor: Colors.grey,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error',
        backgroundColor: Colors.grey,
      );
    }

  }



}