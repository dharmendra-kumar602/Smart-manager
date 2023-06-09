import 'dart:convert';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_manager/dashboard.dart';
import 'company.dart';
class StatusHistory extends StatefulWidget {
  const StatusHistory({Key? key}) : super(key: key);
  @override
  State<StatusHistory> createState() => _StatusHistory();

}

class _StatusHistory extends State<StatusHistory> {



  TextEditingController FromDateController=new TextEditingController();
  TextEditingController FromDateController1=new TextEditingController();
  String dropdownvalue = 'Item 1';
bool  val=false;
  late DateTime _selectedDate;
var StatringDate;
 var formattedDate;
  bool expensionStatus=false;
  var erro;

  var items = [

    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',];

  @override
  void initState() {
    super.initState();
   _resetSelectedDate();
  }

  _resetSelectedDate() {




    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: 0));
      FromDateController1.text=_selectedDate.toString();
      print(FromDateController1);
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      formattedDate = formatter.format(now).toString();
      print(formattedDate);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Status History',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
        leading: BackButton(color: Colors.black45),
      ),
      body:

SingleChildScrollView(

child:Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: CalendarTimeline(
                showYears: true,
                initialDate:DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365*2)),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateSelected: (date){

                 setState(() {
                   print("hello:$date");
                   _selectedDate = date;
                   var   startDateTO=DateTime.parse(_selectedDate.toString());
                   StatringDate = DateFormat("yyyy-MM-dd").format(startDateTO);
                   GetStatusHistoryData();

                 });
                },

                leftMargin: 20,
                monthColor: Colors.black,
                dayColor: Colors.teal[200],
                dayNameColor: Colors.black12,
                activeDayColor: Colors.deepPurple,
                activeBackgroundDayColor: Colors.redAccent[100],
                dotsColor: Colors.black12,
                //selectableDayPredicate: (date) => date.day,
                locale: 'en',
              ) ,
            ),
          ),

          Column(
            children: [
              expensionStatus==true?
              ExpansionTile(
                title: Text("Add Task",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                trailing : expensionStatus==true?Icon(Icons.add,color: Colors.red,size: 30,):Icon(Icons.minimize,color: Colors.red,size: 30,),
                children: [

                  Container(

                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 230),
                          child: Text('Project',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: DropdownButtonFormField(
                            hint: Text('Select Project'),
                            value: dropdownvalue,

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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 250),
                          child: Text('Task',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
                        ),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: DropdownButtonFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          hint: Text('Select Task'),
                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 240),
                          child: Text('Hours',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
                        ),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Hours',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 240),
                          child: Text('Status',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
                        ),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Write Status',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(

                             style: ElevatedButton.styleFrom(
                              primary: Colors.red, // Background color
                             ),
                            onPressed: (){
                            },
                            icon: Center(
                              child: Icon(Icons.add, size: 30,),
                            ),
                            label: Text(' '),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: Text("Smart Manager",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                            trailing : Icon(Icons.add,color: Colors.red,size: 30,),
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                          Text('Task:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                                          Text('smart manager development'),
                                        IconButton(
                                          onPressed: () {

                                            print(val);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {

                                            print('delete');
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ), Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('Hours:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                                        Text('hours'),

                                      ],
                                    ),
                                  ), Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                          Text('Decription:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                                        Text('decription'),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red, // Background color
                                      ),
                                      child: const Text(
                                        'submit',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              )

                            ],
                          ),
                        )


                      ],
                    ),
                  )
                ],

              ):TextField(
               onTap: (){
                 Fluttertoast.showToast(msg:erro);

               },
              ),



    ],
          ),
          Padding(
            padding:  EdgeInsets.only(top: 20),
            child: Container(
                height: 40,
                width: 340,
                child:   ElevatedButton(onPressed:(){

                  GetStatusHistoryData();
                }, child: Text('Show Status History'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background colorss
                  ),
                ),
              ),
          ),
        ],
      ),
    ),);
  }



  GetStatusHistoryData() async{

    Map date={
      'statusDate':StatringDate.toString(),//StatringDate.toString(),
    };
     SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token_id');
    var  UserEntityId =prefs.getString('UserEntityId');
      var response = await http.post(Uri.parse('https://uat.smartmanager.bel-technology.com/api/todayEmpStatus/$UserEntityId'),
          body:date,
          headers: {'Authorization': 'Bearer $token'}
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        var timeData = jsondata['response'];

        expensionStatus=true;

        var timeData1 = timeData['statusdate'];
        print(timeData1);
        setState(() {
        });
      }else{
        var jsondata = jsonDecode(response.body);
         erro=jsondata['message'];
       // Fluttertoast.showToast(msg:erro);
      }


  }

}