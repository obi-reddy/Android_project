import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:unexpiry/screens/lists&items/AddList.dart';
import 'package:unexpiry/screens/lists&items/ListDetail.dart';
import 'package:unexpiry/screens/MonthlyExpenditure.dart';

import '../../Components/custom_button.dart';
import '../../Components/custom_textfield.dart';
import '../../apis/remove_list.dart';
import '../../apis/update_list.dart';
import '../../constants.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
var wdth;
var hght;
class _HomePageState extends State<HomePage> {
  var searchlist;

  var searchflg=false;
  var selectedDate;
  var month='January';
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

  // Future<void> datepicker() async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   final selected = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //   );
  //   // if (selected != null && selected != selectedDate) {
  //   selectedDate = selected!;
  //   if(mounted)
  //     setState(() {
  //
  //     });
  //   //  }
  //   initdata();
  // }
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:  (THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR ,
      body:SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: hght/60,),
                Container(
                  width:wdth/1.1,
                  height:hght/16,
                  // width:widget.width,
                  // height: widget.heidht,
                  decoration:BoxDecoration(
                    border: Border.all(color: Colors.grey,width:0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: TextField(
                        style: TextStyle(color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),
                        onChanged: (value){
                          if(value.trim().isNotEmpty)
                            {
                              searchflg=true;
                              searchlist=value;
                              if(mounted)
                                setState(() {

                                });
                            }
                          else
                            {
                              searchflg=false;
                              searchlist=null;
                              if(mounted)
                                setState(() {

                                });
                            }
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:"  Search",
                            hintStyle: TextStyle(color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),
                            suffixIcon: Icon(Icons.filter_alt_sharp,color: Colors.grey,),
                            prefixIcon: Icon(Icons.search,color: Colors.grey,)
                          // hintStyle: TextStyle(
                          //   color: Colors.black45,
                          //   fontSize: 12,
                          //
                          // )

                        ),
                      ),
                    ),
                  ),

                ),
                SizedBox(height: hght/60,),
                Row(
                  children: [
                    Text("Your lists",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),),
                  ],
                ),
                SizedBox(height: hght/60,),
               StreamBuilder<DocumentSnapshot>(
                 stream: FirebaseFirestore.instance.collection('lists').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                 builder: (context, snapshot) {
                   List<dynamic> list=[];
                   if(!snapshot.hasData)
                     return Center(child: CircularProgressIndicator(),);
                   if(snapshot.hasData&&snapshot.data?.data()!=null){
                     var map=snapshot.data?.data() as Map<dynamic,dynamic>;
                   map.forEach((key, value) {
                     if(int.parse(key.substring(0,key.indexOf('-')))>=DateTime.now().year-1&&int.parse(key.substring(0,key.indexOf('-')))<=DateTime.now().year+1&&searchflg==false)
{
                       list.add({'key': key, 'value': value});
                     // searchlist.add({'key': key, 'value': value});
                     }
                     if(int.parse(key.substring(0,key.indexOf('-')))>=DateTime.now().year-1&&int.parse(key.substring(0,key.indexOf('-')))<=DateTime.now().year+1&&searchflg)
                     {
                       for(int i=0;i<value.length;i++){
                         if(value[i]['newname']!=null&&value[i]['newname'].length>=searchlist.length&&value[i]['newname'].substring(0,searchlist.length).toLowerCase()==searchlist.toLowerCase())
                           list.add({'key': key, 'value': [value[i]]});
                        else if(value[i]['listname'].length>=searchlist.length&&value[i]['listname'].substring(0,searchlist.length).toLowerCase()==searchlist.toLowerCase())
                          list.add({'key': key, 'value': [value[i]]});}
                       // searchlist.add({'key': key, 'value': value});
                     }
                   });}
                   return Column(
                     children: [
                       ...list.map((e){return
                         Column(children: [
                           SizedBox(height: hght/60,),
                           Row(
                             children: [
                               Text(e['key'].toString().substring(e['key'].toString().indexOf('-')+1,e['key'].toString().length),style: TextStyle(fontSize: 16,color: Colors.lightGreen),),
                             ],
                           ),

                           ...e['value'].map((e2){
                             return
                               GestureDetector(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ListDetail(group:e,list:e2)));
                                 },
                                 child: Container(
                                   width:wdth/1.1,
                                   height:hght/16,
                                   decoration:BoxDecoration(
                                     border: Border.all(color: Colors.grey,width:0.5),
                                     borderRadius: BorderRadius.circular(5),
                                   ),
                                   child: Row(
                                     children: [
                                       SizedBox(width: 10,),
                                       Icon(Icons.shopping_cart,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),
                                       SizedBox(width: 10,),
                                       Text("${e2['newname']!=null?e2['newname']:e2['listname']}",style: TextStyle(color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),),
                                       Spacer(),
                                       GestureDetector(
                                           onTap: (){
                                             var subject=TextEditingController();


                                             showGeneralDialog(
                                               context: context,
                                               barrierLabel: "Barrier",
                                               barrierDismissible: true,
                                               barrierColor: BLACK_COLOR.withOpacity(0.5),
                                               transitionDuration: Duration(milliseconds: 700),
                                               pageBuilder: (_, __, ___) {
                                                 return StatefulBuilder(
                                                   builder: (context,setState) {
                                                     return Center(
                                                       child: Container(
                                                         color:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,
                                                         height: 250,
                                                         padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                                                         width: MediaQuery.of(context).size.width,
                                                         child: SizedBox.expand(child:
                                                         Column(children: [
                                                           custom_textfield(hinttitle: 'List name',controller: subject),
                                                           SizedBox(height:10),
                                                           GestureDetector(
                                                               onTap: () async {
                                                                 FocusManager.instance.primaryFocus?.unfocus();
                                                                 await datepicker();
                                                                 setState((){});
                                                               },
                                                               child: custom_textfield(enable:false,hinttitle:selectedDate==null?"Purchase item date":DateFormat('yyy/MM/dd').format(selectedDate))),
                                                           SizedBox(height: 15,),
                                                           custom_button(() async {
                                                             try {

                                                               var templist=e2;
                                                               e['value'].removeWhere((element) => element==e2);

                                                             //  await remove_list(list: e['value'],key: e['key']);
                                                               if(subject.text.trim().isNotEmpty){
                                                                 templist.addAll({'newname':subject.text});
                                                               }
                                                               if(selectedDate!=null){
                                                                 templist['date']=selectedDate;
                                                               }
                                                               e['value'].add(templist);
                                                               await update_list(list:e['value'],key:e['key'],);
                                                               // if(subject.text.trim().length<6){
                                                               //   EasyLoading.showToast('password should be 6 charaters!!');
                                                               //   return;
                                                               // } if(selectedDate==null){
                                                               //   EasyLoading.showToast('please enter current password!!');
                                                               //   return;
                                                               // } if(subject.text.trim().isEmpty)return;
                                                               // await Authentication.updatepassword(subject.text,currentpassword.text);
                                                               // await get_profile();

                                                               if(mounted)
                                                                 setState(() {

                                                                 });
                                                               Navigator.pop(context);
                                                             }catch(e){
                                                               print(e);
                                                             }finally{
                                                               EasyLoading.dismiss();
                                                             }
                                                           }, 'Edit')
                                                         ],)
                                                         ),
                                                         margin: EdgeInsets.symmetric(horizontal: 20),
                                                       ),
                                                     );
                                                   }
                                                 );
                                               },
                                               transitionBuilder: (_, anim, __, child) {
                                                 Tween<Offset> tween;
                                                 if (anim.status == AnimationStatus.reverse) {
                                                   tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
                                                 } else {
                                                   tween = Tween(begin: Offset(1, 0), end: Offset.zero);
                                                 }

                                                 return SlideTransition(
                                                   position: tween.animate(anim),
                                                   child: FadeTransition(
                                                     opacity: anim,
                                                     child: child,
                                                   ),
                                                 );
                                               },
                                             );
                                           },child: Icon(Icons.edit,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,)),
                                       GestureDetector(
                                         onTap: () async {
                                           showGeneralDialog(
                                             context: context,
                                             barrierLabel: "Barrier",
                                             barrierDismissible: false,
                                             barrierColor: BLACK_COLOR.withOpacity(0.5),
                                             transitionDuration: Duration(milliseconds: 700),
                                             pageBuilder: (_, __, ___) {
                                               return Center(
                                                 child: Container(
                                                   color:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,
                                                   height: 140,
                                                   padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                                                   width: MediaQuery.of(context).size.width,
                                                   child: SizedBox.expand(child:
                                                   Column(
                                                     children: [
                                                       Text("Confirmation!!",style: TextStyle(color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,fontSize: 20),),
                                                SizedBox(height: 20,),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: [
                                                         Container(
                                                           width: MediaQuery.of(context).size.width/4,
                                                           child: custom_button(() async {

                                                               Navigator.pop(context);

                                                           }, 'Cancel'),
                                                         ),
                                                         SizedBox(width:10),

                                                         Container(
                                                           width: MediaQuery.of(context).size.width/4,
                                                           child: custom_button(() async {
                                                             try {

                                                               e['value'].removeWhere((element) => element==e2);

                                                               await remove_list(list: e['value'],key: e['key']);
                                                               if(mounted)
                                                                 setState(() {

                                                                 });
                                                               Navigator.pop(context);
                                                             }catch(e){
                                                               print(e);
                                                             }finally{
                                                               EasyLoading.dismiss();
                                                             }
                                                           }, 'Ok'),
                                                         )
                                                       ],),
                                                     ],
                                                   )
                                                   ),
                                                   margin: EdgeInsets.symmetric(horizontal: 20),
                                                 ),
                                               );
                                             },
                                             transitionBuilder: (_, anim, __, child) {
                                               Tween<Offset> tween;
                                               if (anim.status == AnimationStatus.reverse) {
                                                 tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
                                               } else {
                                                 tween = Tween(begin: Offset(1, 0), end: Offset.zero);
                                               }

                                               return SlideTransition(
                                                 position: tween.animate(anim),
                                                 child: FadeTransition(
                                                   opacity: anim,
                                                   child: child,
                                                 ),
                                               );
                                             },
                                           );

                                         },

                                           child: Icon(Icons.delete_forever,color: RED_COLOR,)),
                                     ],
                                   ),

                                 ),
                               );
                           })

                         ],);
                       })

                     ],
                   );
                 }
               ),
                SizedBox(height: hght/60,),
                SizedBox(height: hght/60,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddList()));
                  },
                  child: Container(
                    width:wdth/1.1,
                    height:hght/16,
                    // width:widget.width,
                    // height: widget.heidht,
                    decoration:BoxDecoration(
                      border: Border.all(color: Colors.grey,width:0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.shopping_cart,color: Colors.grey,),
                        SizedBox(width: 10,),
                        Text("+ add new list",style: TextStyle(color: Colors.grey),),
                      ],
                    ),

                  ),
                ),
                SizedBox(height: hght/3,),


                custom_button((){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MonthlyExpenditure()));
                }, "Monthly Ependiture"),
          ],
        ),

      ),
        ),
      ),
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
//

// var hours=mindate.hour;
// var minutes=mindate.minute;
                  var day=mindate.day;
                  var year=mindate.year;
//var seconds=mindate.second;
                  var month=mindate.month;


//                   if(lastday==28&&day==28) {
//                     day = 01;
//                     if(month==12) {
//                       month = 01;
//                       year=year+1;
//                     }
//                     else
//                       month=month+1;
//                     lastDayOfMonth = new DateTime(year,month + 1, 0);
//                     lastday=lastDayOfMonth.day;
//                     lastmonth=lastDayOfMonth.month;
//                     lastyear=lastDayOfMonth.year;
//
//                   }
//                   else if(lastday==29&&day==29) {
//                     day = 01;
//                     if(month==12) {
//                       month = 01;
//                       year=year+1;
//                     }
//                     else
//                       month=month+1;
//                     lastDayOfMonth = new DateTime(year,month + 1, 0);
//                     lastday=lastDayOfMonth.day;
//                     lastmonth=lastDayOfMonth.month;
//                     lastyear=lastDayOfMonth.year;
//
//                   }
//                   else if(lastday==30&&day==30) {
//                     day = 01;
//                     if(month==12) {
//                       month = 01;
//                       year=year+1;
//                     }
//                     else
//                       month=month+1;
//                     lastDayOfMonth = new DateTime(year,month + 1, 0);
//                     lastday=lastDayOfMonth.day;
//                     lastmonth=lastDayOfMonth.month;
//                     lastyear=lastDayOfMonth.year;
//
//                   }
//                   else if(lastday==31&&day==31) {
//                     day = 01;
//                     if(month==12) {
//                       month = 01;
//                       year=year+1;
//                     }
//                     else
//                       month=month+1;
//                     lastDayOfMonth = new DateTime(year,month + 1, 0);
//                     lastday=lastDayOfMonth.day;
//                     lastmonth=lastDayOfMonth.month;
//                     lastyear=lastDayOfMonth.year;
//
//                   }
//                   else
//
//                     day=day+1;
//
//
//



//print(DateFormat('yy/MM/dd').format(mindate));

                  return SfDateRangePicker(
//backgroundColor: Colors.green,

                   // enablePastDates:true,
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
              color:WHITE_COLOR,
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
