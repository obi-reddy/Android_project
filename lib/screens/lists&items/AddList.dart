import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:unexpiry/Components/custom_appbar.dart';
import 'package:unexpiry/Components/custom_heading_text.dart';
import 'package:unexpiry/Components/custom_textfield.dart';
import 'package:unexpiry/screens/profile.dart';
import 'package:intl/intl.dart';
import '../../Components/custom_button.dart';
import '../../constants.dart';
import 'AddItems.dart';
import '../../apis/add_list.dart';
import '../../apis/get_server_datetime.dart';
class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  State<AddList> createState() => _AddListState();
}
var wdth;
var hght;

class _AddListState extends State<AddList> {
  var name =TextEditingController();
  bool value = false;
  var selectedDate;
  var month='January';
  var listflg=false;
  callback(){
    setState(() {
      listflg=true;
    });
  }
  @override
  void initState() {

    //initdata();
    // TODO: implement initState
    super.initState();

  }
  initdata(){
    var tempmonth=selectedDate.month;
    if(tempmonth==1)
    month='January';
    else if(tempmonth==2)
      month='February';
    else if(tempmonth==3)
      month='March';
    else if(tempmonth==4)
      month='April';
    else if(tempmonth==5)
      month='May';
    else if(tempmonth==6)
      month='June';
    else if(tempmonth==7)
      month='July';
    else if(tempmonth==8)
      month='August';
    else if(tempmonth==9)
      month='September';
    else if(tempmonth==10)
      month='October';
    else if(tempmonth==11)
      month='November';
    else if(tempmonth==12)
      month='December';

    setState(() {

    });
  }

  Future<void> _selectDate() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
   // if (selected != null && selected != selectedDate) {
    selectedDate = selected!;
    if(mounted)
      setState(() {

      });
  //  }
    initdata();
  }
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor:(THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR,

        appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.lightGreen
        ),
        title: custom_appbar(),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     // GestureDetector(
        //     //     onTap: (){
        //     //       Navigator.pop(context);
        //     //     },
        //     //     child: Icon(Icons.arrow_back,color: Colors.lightGreen,)),
        //     SizedBox(width: 0.5,),
        //     Text("UnExpiry!",style: TextStyle(color: Colors.lightGreen,fontSize: 24,fontWeight: FontWeight.bold),),
        //
        //     GestureDetector(
        //       onTap: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=>profile()));
        //       },
        //       child: CircleAvatar(
        //         backgroundImage: AssetImage("images/profile.jpg"),
        //       ),
        //     ),
        //   ],
        // ),
        backgroundColor:  (THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,


      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: hght/40,),
              custom_textfield(hinttitle: "Name your list",controller: name,),
              SizedBox(height: hght/60,),
              GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    datepicker() ;

                  },
                  child: custom_textfield(enable:false,hinttitle:selectedDate==null?"Purchase item date":DateFormat('yyy/MM/dd').format(selectedDate))),
              SizedBox(height: hght/60,),
              custom_button(() async {

                if(name.text.trim().isEmpty){
                  EasyLoading.showToast('Name could not be empry!!');
                  return;
                }

               await  add_list(year:selectedDate.year,listid: month,date: selectedDate,name: name.text,callback:callback);
                //Navigator.pop(context);
              }, "Add"),
              SizedBox(height: hght/60,),
              Column(
                children: [
                  Container(width: wdth,
                    height: 0.5,
                    color: Colors.grey,),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_forward_ios_outlined,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),
                          Text("Items",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                        ],
                      ),
                      Text("Expiry",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                      Text("Price",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),

                    ],),
                  SizedBox(height: 4,),
                  (selectedDate==null)?Text(""): StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('listitems').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                      builder: (context, snapshot) {
                        var map;


                        List<dynamic> list=[];
                        if(snapshot.hasData&&snapshot.data?.data()!=null){
                          map=snapshot.data?.data() as Map<dynamic,dynamic>;
                          if(map[selectedDate.year.toString()+'-'+month+name.text]!=null)
                            list=map[selectedDate.year.toString()+'-'+month+name.text];}


                        return Column(
                          children: [
                            ...list.map((e){
                              return
                                Column(children: [
                                  Container(width: wdth,
                                    height: 0.5,
                                    color: Colors.grey,),
                                  SizedBox(height: 4,),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_forward_ios_outlined,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),
                                              Text(e['itemname']??"",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                            ],
                                          ),
                                          Text(DateFormat('dd-MM-yyy').format(e['expirydate'].toDate()),style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR)),
                                          Text("${e['price']} SEK",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),

                                        ],),
                                    ],
                                  ),
                                  SizedBox(height: 4,),



                                ],);
                            })

                          ],
                        );
                      }
                  ),

                ],
              ),

            Row(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,
                  ),
                  child: Checkbox(
                    checkColor: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,

                    value: this.value,
                    onChanged: (bool?value) {
                      if(month.trim().isEmpty||name.text.trim().isEmpty||listflg==false){
                        EasyLoading.showToast('Please add list first!!');
                        return;
                      }
                      setState(() {
                        this.value =value!;
                      });

                      if(value==true)
                        Get.to(()=>AddItems(group:{'key':selectedDate.year.toString()+'-'+month},list:{'listname':name.text}  ,));
                    },
                  ),
                ),
                Text("+ add item",style: TextStyle(color: Colors.grey),)
              ],
            ),
            ],
          ),
        ) ,
      )
    );
  }

  datepicker() {
    FocusManager.instance.primaryFocus?.unfocus();
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            child: StatefulBuilder(
                builder: (context,setState) {

                  DateTime now = new DateTime.now();
                  DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);

                  var lastday=lastDayOfMonth.day;
                  var lastmonth=lastDayOfMonth.month;
                  var lastyear=lastDayOfMonth.year;
                  print(lastmonth);
                  var mindate=DateTime.now();


// var hours=mindate.hour;
// var minutes=mindate.minute;
                  var day=mindate.day;
                  var year=mindate.year;
//var seconds=mindate.second;
                  var month=mindate.month;


                  // if(lastday==28&&day==28) {
                  //   day = 01;
                  //   if(month==12) {
                  //     month = 01;
                  //     year=year+1;
                  //   }
                  //   else
                  //     month=month+1;
                  //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                  //   lastday=lastDayOfMonth.day;
                  //   lastmonth=lastDayOfMonth.month;
                  //   lastyear=lastDayOfMonth.year;
                  //
                  // }
                  // else if(lastday==29&&day==29) {
                  //   day = 01;
                  //   if(month==12) {
                  //     month = 01;
                  //     year=year+1;
                  //   }
                  //   else
                  //     month=month+1;
                  //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                  //   lastday=lastDayOfMonth.day;
                  //   lastmonth=lastDayOfMonth.month;
                  //   lastyear=lastDayOfMonth.year;
                  //
                  // }
                  // else if(lastday==30&&day==30) {
                  //   day = 01;
                  //   if(month==12) {
                  //     month = 01;
                  //     year=year+1;
                  //   }
                  //   else
                  //     month=month+1;
                  //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                  //   lastday=lastDayOfMonth.day;
                  //   lastmonth=lastDayOfMonth.month;
                  //   lastyear=lastDayOfMonth.year;
                  //
                  // }
                  // else if(lastday==31&&day==31) {
                  //   day = 01;
                  //   if(month==12) {
                  //     month = 01;
                  //     year=year+1;
                  //   }
                  //   else
                  //     month=month+1;
                  //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                  //   lastday=lastDayOfMonth.day;
                  //   lastmonth=lastDayOfMonth.month;
                  //   lastyear=lastDayOfMonth.year;
                  //
                  // }
                  // else
                  //
                  //   day=day+1;
                  //
                  //
                  //
                  //
                  //

//print(DateFormat('yy/MM/dd').format(mindate));

                  return SfDateRangePicker(

                    // enablePastDates:false,
                    enableMultiView:false,
                    onSelectionChanged: (value){
                      selectedDate=value.value;
                      setstatefun();
                      Navigator.pop(context);
                    },
                    view: DateRangePickerView.month,
                    // monthViewSettings: DateRangePickerMonthViewSettings(
                    //   weekendDays: <int>[1, 5],
                    // ),

                    minDate: DateTime(year, month,day, 0 , 0, 0),
                    maxDate: DateTime(2050, 01,01, 0 , 0, 0),
                  );
                }
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  void setstatefun() {
    initdata();
    setState((){});
  }
}
