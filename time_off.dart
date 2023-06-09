import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'time_Off_History.dart';



  class TimeOff extends StatefulWidget {
  const TimeOff({Key? key}) : super(key: key);
  @override
  State<TimeOff> createState() =>_timeOff();


}

class _timeOff extends State<TimeOff>{
  final _key = GlobalKey();
 // GlobalKey<ExpansionTileState> _key = GlobalKey();



 // GlobalKey<ExpansionTileState> expansionTileKey =GlobalKey<ExpansionTileState>();
bool picker=false;
var selectedRadio;
var selectedRadio1;
late DateTime formattedDate;
var formattedDateTo;
var  ToDate;
var countr=0;
var StatringDate;
var EndDate;
var fileData;
var institution_setPrefrence__Id;
var TimeOffDays;
var TimeOffLeave;
var DropDownSelected;
var leaveTypeId;
var filePath;
var  tokenName;
var  UserEntityId;
var fullDayValue;
var val;
var ControllerValue;
bool isRadioDisabled = false;






List leaveTypeList=[];
String? _LeaveTypes;
List<String> dropdown=[];

late int selectedIndex;  //where I want to store the selected index
late String initialDropDownVal;


TextEditingController FromDateController=new TextEditingController();
TextEditingController ToDateController=new TextEditingController();
TextEditingController countrController=new TextEditingController();
TextEditingController FileController=new TextEditingController();
TextEditingController TitleController=new TextEditingController();
TextEditingController DecriptionController=new TextEditingController();






List<DropdownMenuItem<String>> dropdownItems = [];

CountLeave() async{
  SharedPreferences prefr_data= await SharedPreferences.getInstance();
  prefr_data.setString('ControllerContLeave', ControllerValue.toString());
}



  @override
  void initState() {
    super.initState();
    selectedRadio=0;
    selectedRadio1=0;
    dropdownlist();
    CountLeave();

print(val);
  }
DateTime date = DateTime.now();
//DateTime datetime=DateTime.now();
  late DateTime startDateTO;

   FromDataPicker()
   {
    showDatePicker(context:  context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025)
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
           FromDateController.text=selectedDate.toString();
           startDateTO=DateTime.parse(selectedDate.toString());
            StatringDate = DateFormat("yyyy-MM-dd").format(startDateTO);
        });
      }
    }
    );
  }



    ToDataPicker()
    {
        showDatePicker(context: context,
        initialDate:startDateTO,  // DateTime.now(),
        firstDate: startDateTO,
        lastDate: DateTime(2025)
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(()
        {

          ToDateController.text=selectedDate.toString();
          ToDate=selectedDate;
          EndDate = DateFormat("yyyy-MM-dd").format(ToDate);
          CountLeaveDate();



        });
      }
    }

    );
  }


  SelectedRadio( val){
     if(ControllerValue==1){
       selectedRadio=val;
       setState(() {
           if (selectedRadio == 1) {
             var n = 1;
             countrController.text = n.toString();
           }
           if (selectedRadio == 2) {
             var n = 0.5;
             countrController.text = n.toString();
           }
       });
     }else{
       selectedRadio=val;
     }
  }

  SelectedRadio1( val){
    setState(() {
      selectedRadio1=val;
    });
  }


  void filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['png', 'pdf', 'doc', 'docx'],
    );
    if (result != null) {
      PlatformFile fileBytes = result.files.first;
      filePath = fileBytes.path;
      // setState(() {
      //   // fileName = fileBytes.name;
      // });
    }
  }





  dropdownlist() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');

    var response = await http.get(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/leaveType?institution_Id=$institution_setPrefrence__Id&channel=app'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      leaveTypeList=jsondata['response'];
    }else{
      var jsondata = jsonDecode(response.body);
      Fluttertoast.showToast(msg:jsondata);
    }
  }


  CountLeaveDate() async {
    var count=0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token_id');
    var institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
    var response = await http.get(Uri.parse(
        'https://uat.smartmanager.bel-technology.com/api/getBusinessDays?institution_Id=$institution_setPrefrence__Id&channel=BROWSER&startDate=$StatringDate&endDate=$EndDate'),
        headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      var timeData = jsondata['data'] as List;
      for(var i=0;i<timeData.length;i++){
        if(timeData[i]['isHoliday']==false){
          count++;
        }
      }
      setState(() {

       countrController.text=count.toString();
        ControllerValue=count;

      });
    }else{
      var jsondata = jsonDecode(response.body);
      Fluttertoast.showToast(msg:jsondata);
    }
  }

  SubmitData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    institution_setPrefrence__Id=prefs.getString('institution_Id_setPrefrence');
     tokenName = prefs.getString('token_id');
    UserEntityId =prefs.getString('UserEntityId');
    var url=Uri.parse('https://uat.smartmanager.bel-technology.com/api/employeeleave/store?institution_Id=1001&channel=App');
    var request = new http.MultipartRequest("POST", url);
    var headers = {'Authorization': "Bearer $tokenName"};
    request.headers.addAll(headers);
   //  Map<String, String> headers = {
   //  'Authorization': 'Bearer $tokenName'};
   //  request.headers.addAll(headers);

    // request.fields['document'] =filePath.toString();
    request.fields['employee_id'] =UserEntityId.toString();
    request.fields['fromdate'] = StatringDate.toString();
    request.fields['todate'] = EndDate.toString();
    request.fields['title'] = TitleController.text;
    request.fields['application'] =DecriptionController.text.toString();
    request.fields['leaveTypeId'] = leaveTypeId.toString();
    request.fields['leaveType'] = TimeOffDays.toString();
    request.fields['isBackDated'] = "0";
    request.fields['leaveDaysCount'] =countrController.text.toString();
    request.fields['typesOfLeave'] = TimeOffLeave.toString();
    request.fields['status'] = "PENDING";
    print(TitleController.text);
    print(DecriptionController.text);
    print(UserEntityId.toString());
    // request.files.add(await http.MultipartFile.fromPath(
    //     "document", filePath.toString()));
  var responseStream = await request.send();
   var response = await http.Response.fromStream(responseStream);

    if (responseStream.statusCode == 200) {
      print('File uploaded successfully!');

    } else {
      print('Error uploading file: ${response.statusCode}');
    }



  }
TextClear() {
  FromDateController.clear();
  ToDateController.clear();
  countrController.clear();
   FileController.clear();
  TitleController.clear();
  DecriptionController.clear();
  if(selectedRadio1!=null){
    selectedRadio1=false;
  }if(selectedRadio!=null){
    selectedRadio=false;
  }
  setState(() {
    DropDownSelected=null;
  });




  Fluttertoast.showToast(
      msg: "Apply Time Off Successfuly Submited",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

  CancelText() {
    FromDateController.clear();
    ToDateController.clear();
    countrController.clear();
    FileController.clear();
    TitleController.clear();
    DecriptionController.clear();
    if(selectedRadio1!=null){
      selectedRadio1=false;
    }if(selectedRadio!=null){
      selectedRadio=false;
    }

    Fluttertoast.showToast(
        msg: "Apply Time Off Cancel Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleSubmit() {
    // Close the ExpansionTile
    setState(() {
      _isExpanded = false;
    });

    // Perform other submit actions
    // ...
  }



@override
  Widget build(BuildContext context) {

return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.white,
    title: Text('Time Off',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 20),),
    leading: BackButton(color: Colors.black45),
  ),
body:
SingleChildScrollView(
  child:Column(
  children: [

    Padding(
      padding: const EdgeInsets.only(top:10),
      child: Container(
        height: 200,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          border: Border.all(
            width: 3,
            color: Colors.red,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(right: 120),
              child: Text('Time Off Balance: ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
           Row(
             children: [
               Padding(
                 padding: const EdgeInsets.only(top: 10,left: 10),
                 child: Text('Other:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
               ),
               Padding(
                 padding: const EdgeInsets.only(left: 120),
                 child: Text('UnPaid Time Off: ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
               ),
             ],
           ) ,Row(
             children: [
               Padding(
                 padding: const EdgeInsets.only(top: 20,left: 10),
                 child: Text('Comp Offs:...',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
               ),
               Padding(
                 padding: const EdgeInsets.only(left: 110,top: 20),
                 child: Text('Paid Time Off: ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
               ),
             ],
           ),Row(
             children: [
               Padding(
                 padding: const EdgeInsets.only(top: 20,left: 10),
                 child: Text('Medical:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
               ),
             ],
           ),

          ],
          ),
        ),
    ),

    ListTile(
      title: Text('Apply Time Off'),
      onTap: _toggleExpansion,
      trailing: _isExpanded ? Icon(Icons.minimize,color: Colors.red,size: 30,) : Icon(Icons.add,color: Colors.red,size: 30,),
    ),

    Visibility(
      visible: _isExpanded,
      child: Column(
        children: [

          Column(
            children:
            [

              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {
                          FromDataPicker();
                        },
                        child: Icon(
                          Icons.calendar_today_outlined,size: 30,color: Colors.black45,
                        ),
                      ),
                    ),
                    Container(
                      //  child: Text('$check_Out_time'),
                      child: SizedBox(
                        height: 40,
                        width: 80,
                        child: TextFormField(
                          //onTap: FromDataPicker(),
                          keyboardType:TextInputType.none,
                          readOnly: true,
                          controller: FromDateController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'FromDate*',
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.only(left: 100),
                      child: Container(
                        child: TextButton(
                          onPressed: () {
                            ToDataPicker();

                          },
                          child: Icon(
                            Icons.calendar_today_outlined,size: 30,color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //  child: Text('$check_Out_time'),
                      child: SizedBox(
                        height: 40,
                        width: 80,
                        child: TextFormField(
                          //onTap: CountLeaveDate(),
                          keyboardType:TextInputType.none,
                          readOnly: true,
                          controller: ToDateController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'toDate*',

                          ),
                        ),
                      ),
                    ),
                    //Text('to Date*',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 20),
                      child: SizedBox(
                        height: 20,
                        width: 100,
                        child: TextField(
                            controller: countrController,
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: "Count",
                                contentPadding: EdgeInsets.only(bottom: 10,left: 10)
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 100),
                      child: SizedBox(
                        height: 60,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                         //   if(leaveTypeList!=null)
                              DropdownButton<String>(
                                value: _LeaveTypes,
                                iconSize: 30,
                                icon: (null),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                hint: Text('Time Off Types*'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _LeaveTypes = newValue;
                                    switch(_LeaveTypes){

                                      case '1' :{
                                        DropDownSelected='Medical';
                                      }break; case '2' :{
                                      DropDownSelected='Paid Time Off';
                                    }break; case '3' :{
                                      DropDownSelected='Comp Offs';
                                    }break; case '4' :{
                                      DropDownSelected='UnPaid Time Off';
                                    }break; case '5' :{
                                      DropDownSelected='Other';
                                    }break;
                                      default: {
                                        setState(() {
                                          DropDownSelected='null';
                                        });

                                      }
                                    }

                                    print(DropDownSelected);
                                    leaveTypeId=_LeaveTypes;
                                    print(leaveTypeId);
                                  });
                                },
                                items: leaveTypeList?.map((item) {
                                  return DropdownMenuItem(
                                    value:
                                    item['leaveTypeId'].toString(),
                                    child:
                                    Text(item['leaveDescription']),
                                  );
                                })?.toList() ??
                                    [],
                              ),
                          ],
                        ),

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(right: 230,top: 30),
                child: Text('Time Off',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Row(
                children: [
                  ButtonBar(
                    children: <Widget>[
                      Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          activeColor: Colors.cyan,
                          onChanged:(ControllerValue!=1)?null: (val){
                            if(val==1){
                              TimeOffDays='Full Day';
                              setState(() {
                                fullDayValue=1;
                              });
                              print(TimeOffDays);
                            }
                            fullDayValue=val;
                            print(val);

                            SelectedRadio(val);            }
                      ),
                      Text('full Day'),
                      Radio(
                          value: 2,
                          groupValue: selectedRadio,
                          activeColor: Colors.cyan,

                          onChanged:(ControllerValue!=1)?null:  (val){
                            if(val==2){
                              TimeOffDays='Half Day';
                              print(TimeOffDays);
                              setState(() {
                                fullDayValue=2;

                              });
                            }
                            print(val);
                            SelectedRadio(val);
                          }
                      ), Text('Half Day'),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(right: 250),
                child: Text('Time Off',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Row(
                children: [
                  ButtonBar(
                    children: <Widget>[
                      Radio(
                          value: 1,
                          groupValue: selectedRadio1,
                          activeColor: Colors.cyan,
                          onChanged: (val){
                            if(val==1){
                              TimeOffLeave='Plan Leave';
                              print(TimeOffLeave);
                            }

                            print(val);
                            SelectedRadio1(val);
                          }
                      ),
                      Text('Plan \n Leave'),
                      Radio(
                          value: 2,
                          groupValue: selectedRadio1,
                          activeColor: Colors.cyan,
                          onChanged: (val){
                            if(val==2){
                              TimeOffLeave='UnPlan Leaves';
                              print(TimeOffLeave);
                            }
                            print(val);
                            SelectedRadio1(val);  }
                      ),
                      Text('UnPlan \n Leaves'),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child:   Container(
                      height: 40,
                      width: 200,
                      child:   ElevatedButton(onPressed:(){
                        filePicker();
                      }, child: Text('Choose file'),style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Background color
                      ),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: 140,
                      height: 60,
                      child: Container(
                        //child:  // Text('no files chosen')
                        child: TextFormField(
                          keyboardType: TextInputType.none,
                          controller: FileController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'No choose file',
                            border: InputBorder.none,

                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10,left: 10),
                child: TextField(
                    controller: TitleController,
                    decoration: InputDecoration(
                      labelText: "Title*",

                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20,left: 10),
                child: TextField(
                    controller:DecriptionController,
                    decoration: InputDecoration(
                      labelText: "Decreption*",
                    )),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 160,
                      child:   ElevatedButton(onPressed:(){
                        // filePicker();
                        setState(() {
                          CancelText();
                        });

                      }, child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Container(
                      height: 30,
                      width: 160,

                      child:   ElevatedButton(

                        onPressed:(){
                          SubmitData();
                          if(SubmitData()!=null){
                            // TextClear();
                            // _handleSubmit();
                            // setState(() {
                            //
                            // });

                          }

                        }, child: Text('Submit'),style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Background color
                      ),),
                    ),
                  )
                ],
              ),
            ],
          ),
          // Text('Expanded content goes here'),
          // ElevatedButton(
          //   child: Text('Submitsss',style: TextStyle(color: Colors.red),),
          //   onPressed: _handleSubmit,
          // ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 40,
        width: 340,
        child:   ElevatedButton(onPressed:(){
          //filePicker();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>TimeOffHistory()));
        }, child: Text('Time Off History'),
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // Background colorss
          ),
        ),
      ),
    ),
  ],
),
)
);
  }

}
