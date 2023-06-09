import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/login.dart';


class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);
  @override
  State<Company> createState() => _CompanyState();

}

class _CompanyState extends State<Company> {
  TextEditingController CompanyEditingController= new TextEditingController();
  TextEditingController institution_config_id= new TextEditingController();

 var companyName;
var response;
var required;
  var error;
  var schemaName;
  var institution_config_detail;
  var preferenc_Company;
  List<String> institution_list=[];
  List<String> institution_list_id=[];
  Map institution_map={};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


 GetData() async{
if(CompanyEditingController.text==null && CompanyEditingController.text.isEmpty){
  //print('Enter valide name');
  return 'Company name is required';
}else{
  response = await http.get(Uri.parse(
      'https://uat.smartmanager.bel-technology.com/api/searchSubdomain?schemaName=${CompanyEditingController.text}'));
  if (response.statusCode == 200) {
    var jsondata=jsonDecode(response.body);
    var data=jsondata['data'];
     schemaName=data['schemaName'];

     SharedPreferences pref_Company=await SharedPreferences.getInstance();
      pref_Company.setString('preferenc_Company_name', schemaName.toString());


    response = await http.get(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/getInstitutionList'));
    if(response.statusCode==200){
      var jsonData=jsonDecode(response.body);
      var dataName=jsonData['response'];
      for(var i=0;i<dataName.length;i++){

          if(schemaName.toString()== dataName[i]['schemaName'].toString()){
          institution_config_detail=dataName[i]['institution_config_detail_id'].toString();
          SharedPreferences prefre =await SharedPreferences.getInstance();
          var institution =  prefre.setString('institution_config_id', institution_config_detail.toString());
          }

      }
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));


  } else {
    if (response.statusCode == 400) {
      var jsonData=jsonDecode(response.body);
       error=jsonData['error'];
    }
    Fluttertoast.showToast(msg: '$error');

  }
}

// setState(() async{
//   CompanyEditingController.text=schemaName;
//
//
//   SharedPreferences prefre =await SharedPreferences.getInstance();
//   var UserName =  prefre.setString('schemaName', schemaName.toString());
//  var institution =  prefre.setString('institution_config_id', institution_config_detail.toString());
//
//
// });


  }



  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body:
         Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 80),
                  width: 250,
                  child: Image.asset('assets/smartmanager.png',),
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                     padding:  EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Text("Enter Your Company Here",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                     padding: const EdgeInsets.only(left: 40,right: 40),
                    child: Container(
                       margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: CompanyEditingController,
                        decoration: InputDecoration(
                          hintText: 'Company Name',
                          border: OutlineInputBorder(),
                        ),
                      ),

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40),
                    child: Container(
                      width: 400,
                      height:50,
                      margin: EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed:(){
                          GetData();
                        },
                        style: ElevatedButton.styleFrom(primary:Colors.red),
                        child: Text("Submit",
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                 ],
              ),
            ),

          ],
        ),

    ),
  );

  }

}