import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
import 'time_off.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  TextEditingController CompanyEditingController= new TextEditingController();
  bool passwordVisible=false;
  bool _passwordVisible=false;
  var intittution;
  var error;
  var response;
  var fname;
  var lname;
  var profilePic;
  var entityId;
  var Token;
  var institution_Id;
  var userIdName;
  TextEditingController userName=new TextEditingController();
  TextEditingController password=new TextEditingController();
  @override
  void initState(){
    super.initState();
    passwordVisible=true;


  }




GetData() async {
    if(userName.text.isNotEmpty && password.text.isNotEmpty) {

      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(password.text.toString());
      String decoded = stringToBase64.decode(encoded);
      SharedPreferences pref = await SharedPreferences.getInstance();
      intittution = pref.getString('institution_config_id');

      Map ParameterMap = {
        'userName': userName.text.toString(),
        'password': encoded.toString(),
        'institution_Id': intittution.toString(),
      };
      var response = await http.post(Uri.parse(
          'https://uat.smartmanager.bel-technology.com/api/login?channel=app'),
          body: ParameterMap);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        var data=jsondata['response'];
         Token=jsondata['token'];
        fname=data['fName'];
        lname=data['lName'];
        entityId=data['entityId'];
        profilePic=data['profilePic'];
        var institution_Id_data=data['reportingEmployeePhone'];
         institution_Id=institution_Id_data['institution_Id'];
        SharedPreferences prefr_data= await SharedPreferences.getInstance();
        prefr_data.setString('firstName', fname.toString());
        prefr_data.setString('lastName', lname.toString());
        prefr_data.setString('UserProfilePic', profilePic.toString());
        prefr_data.setString('UserEntityId', entityId.toString());
        prefr_data.setString('token_id', Token.toString());
        prefr_data.setString('institution_Id_setPrefrence', institution_Id.toString());
        prefr_data.setString('userIdName', userName.toString());
        prefr_data.setString('UserEntityId', entityId.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>DashBoard()));

      } else {
        if (response.statusCode == 400) {
          var jsonData = jsonDecode(response.body);
          error = jsonData['message'];
        }
       Fluttertoast.showToast(msg: '$error');

      }
    }else if(userName.text.isEmpty){
      Fluttertoast.showToast(msg: 'userName  Field is Required');
    }else if( password.text.isEmpty){
      Fluttertoast.showToast(msg: 'password Field is Required');

    }



  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Text("Welcome Back",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: userName,
                        decoration: InputDecoration(
                          hintText: 'UserName',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.email_rounded,color: Colors.red,)),
                        ),


                      ),

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: password,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                            suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,color: Colors.red,),
                            onPressed: () {
                              setState(
                                    () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),

                      ),

                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30,top: 20),
                            child: TextButton(
                            onPressed: () {
                             // GetData();
                            },
                            style: TextButton.styleFrom(primary: Colors.white),
                            child: Text("Forgot Password ?",
                            style: TextStyle(color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                                ),
                             ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 70,top: 20),

                            child:ElevatedButton(

                              onPressed: () {
                                GetData();
                              },
                              child: Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black45,
                                shape: CircleBorder(), //<-- SEE HERE
                                padding: EdgeInsets.all(20),
                              ),
                            ),
                          ),
                        ],
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
  }}