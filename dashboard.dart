import 'dart:convert';
import 'package:smart_manager/Employee_Wise_Leave_Reports.dart';
import 'package:smart_manager/time_Of_By_Persion.dart';

import 'Finance_Received_Request.dart';
import 'My_Claim.dart';
import 'add_Claim.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_manager/time_off.dart';
import 'Reimbursement.dart';
import 'model/loginModel.dart';
import 'status_History.dart';
import 'my_Profile.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Response> login=[];
  var UserFirstName;
  var UserLastName;
  var UserProfilePic_Image;
  var UserEntityId;
  var loaction="null, press";
  var Address="search";
  var latitude_data;
  var longitude_data;
  var Token_Id;
  var Token;
  var institution_setPrefrence__Id;
  var formattedDate;
  var time_In_Data;
  var time_Out_Data;
  var formatted_In_Time;
  var check_in_time;
  var formatted_Out_Time;
  var check_Out_time;
  var check_in_time_popup;
  var check_out_time_popup;
  var  check_date_popup;
  var check_in_time_popup2;
  var check_out_time_popup2;
  var  check_date_popup2;

  var check_in_time_popup3;
  var check_out_time_popup3;
  var  check_date_popup3;

  var fname1;
  var lname1;
  var dob1;
  var fname2;
  var lname2;
  var dob2;
  var fname3;
  var lname3;
  var dob3;
  var formatterSat;
  var formatterPastOneDays;


  TextEditingController checkInController=new TextEditingController();
  TextEditingController checkOUTController=new TextEditingController();


  TextEditingController date_Popup_Controller1=new TextEditingController();
  TextEditingController checkIn_Popup_Controller1=new TextEditingController();
  TextEditingController checkOut_Popup_Controller1=new TextEditingController();

  TextEditingController date_Popup_Controller2=new TextEditingController();
  TextEditingController checkIn_Popup_Controller2=new TextEditingController();
  TextEditingController checkOut_Popup_Controller2=new TextEditingController();

  TextEditingController date_Popup_Controller3=new TextEditingController();
  TextEditingController checkIn_Popup_Controller3=new TextEditingController();
  TextEditingController checkOut_Popup_Controller3=new TextEditingController();


  @override
  void initState(){
    super.initState();
    GetData();
    Check_In_Date();
    BirthdayData();
    getPopup();
  }




   GetData() async{
    SharedPreferences pref_get_data=await SharedPreferences.getInstance();
    setState(() {      UserFirstName =pref_get_data.getString('firstName');
      UserLastName =pref_get_data.getString('lastName');
      UserProfilePic_Image =pref_get_data.getString('UserProfilePic');
      UserEntityId =pref_get_data.getString('UserEntityId');
      Token_Id =pref_get_data.getString('token_id');
      institution_setPrefrence__Id=pref_get_data.getString('institution_Id_setPrefrence');
    });
  }


    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      //GetLonitude_data();
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }


      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      return await Geolocator.getCurrentPosition();
    }

    Future<void> GetAdressFromLatLong (Position position) async{
     List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
//print(placemark);
//Placemark place= placemark[0];
//Address='${place.street},${place.subLocality}';
//     print(latitude_data);
//     print(longitude_data);
    }

    GetLonitude_data() async{
      Map latLong_Id={
        'employeeId':'$UserEntityId'.toString(),
        'longitudeCode':'$longitude_data'.toString(),
        'latitudeCode':'$latitude_data'.toString(),
        'attendanceType':'CHECKIN'.toString(),
      };
//{{baseUrl}}/attendance/store?institution_Id=1001&channel=App
      var response = await http.post(Uri.parse(
          'https://uat.smartmanager.bel-technology.com/api/attendance/store?institution_Id=$institution_setPrefrence__Id&channel=App'),
        body: latLong_Id,
          headers: {
          'Authorization': 'Bearer $Token_Id '}
      );
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        var Check_In_Data=jsondata['data'];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>DashBoard()));

      }else{
        var jsondata = jsonDecode(response.body);
        Fluttertoast.showToast(msg: jsondata);
      }

    }


  Check_In_Date() async{
    var now = new DateTime.now();
    // now_1w= now.subtract(Duration(days: 7));
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    //print(now_1w);

     SharedPreferences prefs = await SharedPreferences.getInstance();
     var token = prefs.getString('token_id');
    var response = await http.get(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/attendanceByUserId/$UserEntityId?institution_Id=$institution_setPrefrence__Id&channel=app&start=$formattedDate&end=$formattedDate'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var timeData = jsondata['data'] as List;
      var timeInIndex = timeData[0];

      if(timeInIndex['timeIn']!=null){
        time_In_Data = timeInIndex['timeIn'];}
       formatted_In_Time = DateTime.parse(time_In_Data);
       check_in_time = DateFormat('hh:mm a').format(formatted_In_Time);
      setState(() {
        checkInController.text=check_in_time;

      });
      if(timeInIndex['timeOut']!=null){
      time_Out_Data = timeInIndex['timeOut'];
      formatted_Out_Time = DateTime.parse(time_Out_Data);
       check_Out_time = DateFormat('hh:mm a').format(formatted_Out_Time);
      setState(() {
        checkOUTController.text=check_Out_time;
      });
      }
       print(checkOUTController);

    }else{
      var jsondata = jsonDecode(response.body);
        print(jsondata);
    }
  }



  CheckOutData() async {
    Map latLong_Id={
      'employeeId':'$UserEntityId'.toString(),
      'longitudeCode':'$longitude_data'.toString(),
      'latitudeCode':'$latitude_data'.toString(),
      'attendanceType':'CHECKOUT'.toString(),
    };
//{{baseUrl}}/attendance/store?institution_Id=1001&channel=App
    var response = await http.post(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/attendance/store?institution_Id=$institution_setPrefrence__Id&channel=App'),
        body: latLong_Id,
        headers: {
          'Authorization': 'Bearer $Token_Id'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Check_In_Date();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>DashBoard()));
    }else{
      var jsondata = jsonDecode(response.body);
       Fluttertoast.showToast(msg: jsondata);
       print(jsondata);
    }
  }


  List<String> timeHistory=[];
  List<String> timeHistory1=[];
  List<String> timeHistory2=[];

getPopup()  async{

    var now = new DateTime.now();
    var pastDays = DateTime.now().subtract(Duration(days: 6));
    var pastOneDays = DateTime.now().subtract(Duration(days: 1));


     formatterSat =  DateFormat('yyyy-MM-dd').format(pastDays);
     formatterPastOneDays =  DateFormat('yyyy-MM-dd').format(pastOneDays);


    print(formatterSat);
    print(formatterPastOneDays);
    var formatter = new DateFormat('yyyy-MM-dd');
    var k=0;
    formattedDate = formatter.format(now);
   // print(formattedDate);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var response = await http.get(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/attendanceByUserId/$UserEntityId?institution_Id=$institution_setPrefrence__Id&channel=app&start=$formatterSat&end=$formatterPastOneDays'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var timeData = jsondata['data'] as List;
      for(var i=timeData.length;i>=0;i--){
        var dateCurr= timeData[i-1]['currentDate'];
        List holidayArr=timeData[i-1]['currentDateHolidayArr'] as List;
        if(holidayArr.length < 1)
        {
          if(timeData[i-1]['isAbsent']==false)
          {
            var check_out_time_popup3 ="";
            var add = DateTime.parse(timeData[i-1]['timeIn'].toString());
            var formatted_In_Time_popup3 = DateFormat.jm().format(add);
            if(timeData[i-1]['timeOut']!=null) {
              var add1 = DateTime.parse(timeData[i-1]['timeOut'].toString());
              check_out_time_popup3 = DateFormat.jm().format(add1);
            }
            if(k==0){
              setState(() {
                checkOut_Popup_Controller1.text =check_out_time_popup3.toString();
                checkIn_Popup_Controller1.text = formatted_In_Time_popup3.toString();
                date_Popup_Controller1.text = timeData[i-1]['currentDate'];
                k++;
              });
            }else if(k==1){
              setState(() {
                checkOut_Popup_Controller2.text =check_out_time_popup3.toString();
                checkIn_Popup_Controller2.text = formatted_In_Time_popup3.toString();
                date_Popup_Controller2.text = timeData[i-1]['currentDate'];
                k++;
              });
            }else if(k==2){
              setState(() {
                checkOut_Popup_Controller3.text =check_out_time_popup3.toString();
                checkIn_Popup_Controller3.text = formatted_In_Time_popup3.toString();
                date_Popup_Controller3.text = timeData[i-1]['currentDate'];
                k++;
              });
            }
            }else{
            if(k==0){
              setState((){
                date_Popup_Controller1.text = timeData[i-1]['currentDate'];
                k++;
              });
            }else if(k==1){
              setState(() {
                date_Popup_Controller2.text = timeData[i-1]['currentDate'];
                k++;
              });
            }else if(k==2){
              setState(() {
                date_Popup_Controller3.text = timeData[i-1]['currentDate'];
                k++;
              });
            }
            }
      }
     }
    }else{
      var jsondata = jsonDecode(response.body);
      Fluttertoast.showToast(msg:jsondata);
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: add_card',
      style: optionStyle,
    ),
    Text(
      'Index 2: person',
      style: optionStyle,
    ),Text(
      'Index 3: add_chart',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BirthdayData()  async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var response = await http.get(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/birthdayList?institution_Id=$institution_setPrefrence__Id'), headers: {
          'Authorization': 'Bearer $Token_Id'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var data=jsondata['response'] as List;
      for(var i=0;i<data.length;i++){
        if(i==0){
           fname1=data[i]['fName'];
           lname1=data[i]['lName'];
           dob1=data[i]['dob'];
        }else if(i==1){
           fname2=data[i]['fName'];
           lname2=data[i]['lName'];
           dob2=data[i]['dob'];
        }else if(i==2){
           fname3=data[i]['fName'];
           lname3=data[i]['lName'];
           dob3=data[i]['dob'];
        }
      }


    }else{
      var jsondata = jsonDecode(response.body);
       Fluttertoast.showToast(msg: jsondata);
    }
  }


  @override
  Widget build(BuildContext context) {

   return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        leading: Padding(
          padding:  EdgeInsets.only(left:10,top: 10,bottom: 5),
          child: Container(
              child: Padding(
                padding:  EdgeInsets.only(),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage:UserProfilePic_Image!=null ? AssetImage(UserProfilePic_Image):AssetImage('assets/cake.png'),
                ),
              )
          ),
        ),
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [

     Padding(
       padding:  EdgeInsets.only(top: 10),
       child: Container(
         child: Text('Hi $UserFirstName $UserLastName',style: TextStyle(color: Colors.black,fontSize: 20),),
       ),
     ),
     Padding(
       padding:  EdgeInsets.only(left:80,top: 10),
       child: Container(
         height: 30,
         width: 30,
         child: //Image.asset('assets/sign-out.png'),
         ImageIcon(AssetImage('assets/sign-out.png'),color: Colors.black,),
       ),
       ),
      ],
        ),
        ),
        body:SingleChildScrollView(
        child:
            Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 15,top: 10,right: 15),
                      child: Container(
                        width: 360,
                        height: 250,
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
                            Padding(
                              padding:  EdgeInsets.only(right: 200,bottom: 15),
                              child: Text('Attendance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(left:0),
                                  child: Container(
                                    height: 30,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      onPressed: ()async{
                                        Position position=await _determinePosition();
                                        latitude_data=position.latitude.toString();
                                        longitude_data=position.longitude.toString();
                                        GetLonitude_data();
                                        Check_In_Date();
                                        // print(latitude_data);
                                        // print(longitude_data);
                                        //print(position.latitude);
                                        loaction ='lat:${position.latitude},long:${position.longitude}';
                                        GetAdressFromLatLong(position);

                                        setState(() {

                                        });
                                        },
                                      child: Text('Check In'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 75),
                                  child: Container(
                                    height: 30,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      onPressed: ()async{
                                        Position position=await _determinePosition();
                                        latitude_data=position.latitude.toString();
                                        longitude_data=position.longitude.toString();
                                        CheckOutData();

                                        loaction ='lat:${position.latitude},long:${position.longitude}';
                                        GetAdressFromLatLong(position);
                                      },
                                      child: Text('Check Out'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(left: 30,top: 10),
                                  child: Container(
                                    //child: //Text('$check_in_time'),
                                      child: SizedBox(
                                        height: 40,
                                        width: 80,
                                        child: TextFormField(
                                          keyboardType:TextInputType.none,
                                            readOnly: true,
                                            controller:  checkInController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,

                                          ),

                                          ),

                                      ),
                                    ),
                               ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 120),
                                  child: Container(
                                  //  child: Text('$check_Out_time'),
                                    child: SizedBox(
                                      height: 40,
                                      width: 80,
                                      child: TextFormField(
                                        keyboardType:TextInputType.none,
                                        readOnly: true,
                                        controller: checkOUTController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                  ),
                                ),
                                ),
                              ],
                            ),
                           Padding(
                             padding:  EdgeInsets.only(top: 40),
                             child: Container(
                               child: ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   primary: Colors.red,
                                 ),
                                 onPressed: (){
                                   showDialog(
                                     barrierDismissible: false,
                                     context: context,
                                     builder: (BuildContext context) =>
                                         _buildPopupDialog(context),
                                   );
                                   },
                                 child: Text('Showrecord'),
                               ),
                             ),
                           ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 10),
                  child: Container(
                    height: 30,
                    width: 380,
                    padding: EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: (){},
                      child: Text('where I am'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200,top: 10),
                  child: Text('Quick Links',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                SingleChildScrollView(child:
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child:
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                       child: Ink.image(
                         child:InkWell(
                           onTap: () {

                             Navigator.push(
                                 context, MaterialPageRoute(builder: (context) =>TimeOfByPersion()));
                           },),
                         image: AssetImage('assets/tie.png'),
                       ),
                            ),
                            Text('My Profile' )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                     child:  Ink.image(
                       child:InkWell(
                         onTap: () {

                           Navigator.push(
                               context, MaterialPageRoute(builder: (context) =>StatusHistory()));
                         },),
                       image: AssetImage('assets/status.png'),
                     ),
                            ),
                            Text('Status'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                     child:  Ink.image(
                       child: InkWell(
                         onTap: () {

                           Navigator.push(
                               context, MaterialPageRoute(builder: (context) =>FinanceReceivedRequest())); //MyClaim ReimburseMent AddClaim
                         },),
                       image: AssetImage('assets/Task.png'),
                     ),
                            ),
                            Text('Reimbursement'),
                          ],
                        ),
                        
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                        child:  Ink.image(
                          child: InkWell(
                            onTap: () {

                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>EmployeeLeave()));
                              },),
                          image: AssetImage('assets/Time_off.png'),

                        ),
                            ),
                            Text('Time Off')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    ),
               Column(
                 children: [
                   Padding(
                     padding: EdgeInsets.only(top: 10),
                     child: ExpansionTile(title: Text('Birthday And Anniversary',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           children: [
                             Padding(
                               padding:  EdgeInsets.only(left: 10,),
                               child: Container(
                                 child:CircleAvatar(
                                   radius: 30,
                                   backgroundImage:NetworkImage('https://www.whatsappimages.in/wp-content/uploads/2020/05/Cute-Dp-Images-71.jpg'),
                                 ) ,
                               ),
                             ),
                             Padding(
                               padding: EdgeInsets.only(left: 30),
                               child: RichText(text: TextSpan(
                                 children: <TextSpan>[
                                   TextSpan(
                                     text: '$fname1 $lname1 \n',
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 20,
                                     )
                                   ),
                                   TextSpan(text: '$dob1',style: TextStyle(color: Colors.black))
                                 ]
                               )),
                             )
                             //Text('Ram Kumar \n 21-12-2020')
                           ],
                         ),
                       ),
                       Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Row(
                           children: [
                             Padding(
                               padding:  EdgeInsets.only(left: 10),
                               child: Container(
                                 child:CircleAvatar(
                                   radius: 30,
                                   backgroundImage:NetworkImage('https://images.unsplash.com/photo-1628851479386-3f6db0efa7fa?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGN1dGUlMjBib3l8ZW58MHx8MHx8&w=1000&q=80'),
                                 ) ,
                               ),
                             ),
                             Padding(
                               padding:  EdgeInsets.only(left: 30),
                               child: RichText(text: TextSpan(
                                   children: <TextSpan>[
                                     TextSpan(
                                         text: '$fname2 $lname2 \n',
                                         style: TextStyle(
                                           color: Colors.black,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 20,
                                         )
                                     ),
                                     TextSpan(text: '$dob2',style: TextStyle(color: Colors.black))
                                   ]
                               )),
                             )
                             //Text('Ram Kumar \n 21-12-2020')
                           ],
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           children: [
                             Padding(
                               padding:  EdgeInsets.only(left: 10),
                               child: Container(
                                 child:CircleAvatar(
                                   radius: 30,
                                   backgroundImage:NetworkImage('https://images.pexels.com/photos/35537/child-children-girl-happy.jpg?cs=srgb&dl=pexels-bess-hamiti-35537.jpg&fm=jpg'),
                                 ) ,
                               ),
                             ),
                             Padding(
                               padding:  EdgeInsets.only(left: 30),
                               child: RichText(text: TextSpan(
                                   children: <TextSpan>[
                                     TextSpan(
                                         text: '$fname3 $lname3 \n',
                                         style: TextStyle(
                                           color: Colors.black,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 20,
                                         )
                                     ),
                                     TextSpan(text: '$dob3',style: TextStyle(color: Colors.black))
                                   ]
                               )),
                             )
                             //Text('Ram Kumar \n 21-12-2020')
                           ],
                         ),
                       ),
                     ],
                     ),
                   ),Padding(
                     padding: EdgeInsets.only(top: 10),
                     child: ExpansionTile(title: Text('Holidays',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                     children: [
                       Row(
                         children: [
                           Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 10),
                                 child: Text('No Holidays Todays',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(left: 10),
                                 child: Text('today,s Holidays'),
                               ),
                     Container(
                       height: 80,
                       width: 80,
                       child:  Ink.image(
                         image:AssetImage('assets/diwali.png'),
                            ),)
                             ],
                           ),
                           Column(

                             children: [
                               Text('Upcoming Holidays',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                               Row(
                               //  mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Padding(
                                     padding:  EdgeInsets.only(left: 10),
                                     child: Container(
                                       height: 40,
                                       width: 40,
                                       child:  Ink.image(
                                         image:AssetImage('assets/diwali.png'),
                                       ),),
                                   ),
                                   Padding(
                                     padding:  EdgeInsets.only(left: 30),
                                     child: RichText(text: TextSpan(
                                         children: <TextSpan>[
                                           TextSpan(
                                               text: 'Independence Day \n',
                                               style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 15,
                                               )
                                           ),
                                           TextSpan(text: '15-8-2020',style: TextStyle(color: Colors.black))
                                         ]
                                     )),
                                   ),
                                 ],
                               ),
                               Row(
                                 children: [
                                   Padding(
                                     padding:  EdgeInsets.only(left: 10),
                                     child: Container(
                                       height: 40,
                                       width: 40,
                                       child:  Ink.image(
                                         image:AssetImage('assets/diwali.png'),
                                       ),),
                                   ),
                                   Padding(
                                     padding:  EdgeInsets.only(left: 30),
                                     child: RichText(text: TextSpan(
                                         children: <TextSpan>[
                                           TextSpan(
                                               text: 'Raksha Bandhan \n',
                                               style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 15,
                                               )
                                           ),
                                           TextSpan(text: '2-8-2020',style: TextStyle(color: Colors.black))
                                         ]
                                     )),
                                   ),
                                 ],
                               ),
                               Row(
                                 children: [
                                   Padding(
                                     padding:  EdgeInsets.only(right: 20),
                                     child: Container(
                                       height: 40,
                                       width: 40,
                                       child:  Ink.image(
                                         image:AssetImage('assets/diwali.png'),
                                       ),),
                                   ),
                                   Padding(
                                     padding: EdgeInsets.only(left: 10),
                                     child: RichText(text: TextSpan(
                                         children: <TextSpan>[
                                           TextSpan(
                                               text: 'Gandhi Jayanti\n',
                                               style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 15,
                                               )
                                           ),
                                           TextSpan(text: '2-10-2020',style: TextStyle(color: Colors.black))
                                         ]
                                     )),
                                   ),
                                 ],
                               ),
                             ],
                           )
                         ],
                       ),
                     ],
                     ),
                   )
                 ],
               ),
              ]
    ),


   ),
     bottomNavigationBar: Container(
       height: 80,
       width: 100,
       decoration: BoxDecoration(
         borderRadius:  BorderRadius.only(
           topLeft:  Radius.circular(30.0),
           bottomLeft:  Radius.circular(30.0),
         ),
         // border: Border.all(
         //   width: 3,
         //   // color: Colors.green,
         //   // style: BorderStyle.solid,
         // ),
       ),
       child: BottomNavigationBar(
         backgroundColor: Colors.grey,
           type: BottomNavigationBarType.fixed,
         unselectedLabelStyle: const TextStyle(color: Colors.green, fontSize: 14),
         items: const <BottomNavigationBarItem>[

           BottomNavigationBarItem(
             icon: Icon(Icons.home,size:40,),
             label: 'Home',
             backgroundColor: Colors.red,

           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.add_card,size:40,),
             label: 'Status',
             backgroundColor: Colors.green,
           ),

           BottomNavigationBarItem(
             icon: Icon(Icons.person,size:40,),
             label: 'Profile',
             backgroundColor: Colors.purple,
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.add_chart,size:40,),
             label:'Reimbursement',
             backgroundColor: Colors.pink,
           ),
         ],
         currentIndex: _selectedIndex,
         selectedItemColor: Colors.amber[800],
         onTap: _onItemTapped,
       ),
     ),

   );

  }


  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 220,horizontal: 60),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0)

              )
          ),
          elevation: 5,

          alignment: Alignment.center,
          title: const Text(
            'Attendance History',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(

            scrollDirection: Axis.horizontal,
            // scrollDirection: Axis.vertical,
            child:
            Row(

              children: [
                Column(
                  children: [
                    // Text('Date Records'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date Records',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          //child: Text('$date_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  date_Popup_Controller1,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          //  child: Text('$checkIn_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  date_Popup_Controller2,
                              decoration: InputDecoration(
                                //  border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Text('$checkOut_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  date_Popup_Controller3,
                              decoration: InputDecoration(
                                //  border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('CheckIn Records',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          //child: Text('$date_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  checkIn_Popup_Controller1,
                              decoration: InputDecoration(
                                //border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          //  child: Text('$checkIn_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  checkIn_Popup_Controller2,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Text('$checkOut_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  checkIn_Popup_Controller3,
                              decoration: InputDecoration(
                                //  border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color:Colors.white,
                              // borderRadius: BorderRadius.only(
                              //     bottomLeft: Radius.circular(16.0),
                              //     bottomRight: Radius.circular(16.0)
                              // ),
                            ),
                            child:  Center(
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.red,fontSize: 25.0,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap:(){
                            Navigator.pop(context);
                          },
                        )                      ],
                    )
                  ],
                ),Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('CheckOut Records',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          //child: Text('$date_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  checkOut_Popup_Controller1,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          //  child: Text('$checkIn_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  checkOut_Popup_Controller2,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Text('$checkOut_Popup_Controller1'),
                          child:SizedBox(
                            height: 40,
                            width: 80,
                            child: TextFormField(
                              keyboardType:TextInputType.none,
                              readOnly: true,
                              controller:  checkOut_Popup_Controller3,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // InkWell(
                //   child: Container(
                //     padding: EdgeInsets.only(top:205,bottom:15,left: 10),
                //     decoration: BoxDecoration(
                //       color:Colors.white,
                //       borderRadius: BorderRadius.only(
                //           bottomLeft: Radius.circular(16.0),
                //           bottomRight: Radius.circular(16.0)),
                //     ),
                //     child:  Text(
                //       "Close",
                //       style: TextStyle(color: Colors.red,fontSize: 25.0,fontWeight: FontWeight.bold),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                //   onTap:(){
                //     Navigator.pop(context);
                //   },
                // )
              ],
            ),
            
          ),
      );
  }



  }
