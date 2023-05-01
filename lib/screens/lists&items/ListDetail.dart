import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:unexpiry/Components/custom_appbar.dart';
import 'package:unexpiry/screens/profile.dart';
import 'package:intl/intl.dart';

import '../../Components/custom_button.dart';
import '../../Components/custom_textfield.dart';
import '../../apis/remove_item.dart';
import '../../apis/update_item.dart';
import '../../constants.dart';
import 'AddItems.dart';
import '../../apis/get_total_expense.dart';
class ListDetail extends StatefulWidget {
  final group;
  final list;

   ListDetail({this.group,this.list});

  @override
  State<ListDetail> createState() => _ListDetailState();
}
var wdth;
var hght;
class _ListDetailState extends State<ListDetail> {
  var selectedDate;
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

  }
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,

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
        backgroundColor:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,


      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  if (index==0)
                  Row(
                    children: [
                      Text(widget.list['newname']!=null?widget.list['newname']:widget.list['listname'],style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  if (index==0)
                  SizedBox(height: hght/60,),
                  if (index==0)
                    Row(
                      children: [
                        Text("Purchase date: ${DateFormat('dd-MM-yyy').format(widget.list['date'].toDate())}",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR)),
                      ],
                    ),
                  if (index==0)
                    FutureBuilder(
                      future:get_total_expense(widget.group['key']+widget.list['listname']+'ex'),
                      builder: (context,snapshot) {
                        return Row(
                          children: [
                            Text("Total expenditure: ${snapshot.data} SEK",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR)),
                          ],
                        );
                      }
                    ),
                  if (index==0)
                    SizedBox(height: hght/60,),
                  if (index==0)
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
                            Icon(Icons.arrow_forward_ios_outlined,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),
                            Text("Items",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                          ],
                        ),
                        Text("Expiry",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                        Text("Price",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                        Text("Actions",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),

                      ],),
                      SizedBox(height: 4,),

                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('listitems').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                      builder: (context, snapshot) {
                        var map;


                        List<dynamic> list=[];
                        if(snapshot.hasData&&snapshot.data?.data()!=null){
                          map=snapshot.data?.data() as Map<dynamic,dynamic>;
                          if(map[widget.group['key']+widget.list['listname']]!=null)
                            list=map[widget.group['key']+widget.list['listname']];}

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
                                Icon(Icons.arrow_forward_ios_outlined,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),
                                Text(e['newname']!=null?e['newname']:e['itemname']??"",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                ],
                                ),
                                Text(DateFormat('dd-MM-yyy').format(e['expirydate'].toDate()),style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                Text("${e['price']} SEK",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                  GestureDetector(
                                      onTap: (){
                                        var name=TextEditingController();
                                        var price=TextEditingController();


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
                                                      height: 300,
                                                      padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                                                      width: MediaQuery.of(context).size.width,
                                                      child: SizedBox.expand(child:
                                                      Column(children: [
                                                        custom_textfield(hinttitle: 'Item name',controller: name),
                                                        SizedBox(height: 15,),
                                                       GestureDetector(
                                                          onTap: () async {
                                                            await datepicker();
                                                            setState((){});
                                                          },
                                                          child: custom_textfield(enable:false,hinttitle:selectedDate==null?'Expiry Date': DateFormat('yyy/MM/dd').format(selectedDate)),),
                                                        SizedBox(height: 15,),
                                                        custom_textfield(hinttitle: 'Price',controller: price,type:TextInputType.number),
                                                        SizedBox(height:10),


                                                        custom_button(() async {
                                                          try {
print(list);
                                                            var templist=e;
                                                            var lastprice=e['price'];
                                                            print(lastprice);
                                                            print("********************");
                                                           list.removeWhere((element) => element==e);

                                                            //  await remove_list(list: e['value'],key: e['key']);
                                                            if(name.text.trim().isNotEmpty){
                                                              templist.addAll({'newname':name.text});
                                                            }
                                                            if(price.text.trim().isNotEmpty){
                                                              templist['price']=price.text.replaceAll(',', '');
                                                            }
                                                            if(selectedDate!=null){
                                                              templist['expirydate']=selectedDate;
                                                            }
                                                            list.add(templist);
                                                            await update_item(list:list,key:widget.group['key']+widget.list['listname'],price:price.text.replaceAll(',', ''),lastprice: lastprice,listname:widget.group['key']);
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
var lastprice=e['price'];

                                                              list.removeWhere((element) => element==e);

                                                              await remove_item(list: list,key: widget.group['key']+widget.list['listname'],lastprice: lastprice,listname:widget.group['key'] );
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
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItems(group:widget.group,list:widget.list)));
          // Add your onPressed code here!
        },
        backgroundColor: Colors.green,
        child:  Text("Add",style: TextStyle(color:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR),),
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
    setState((){});
  }
}
