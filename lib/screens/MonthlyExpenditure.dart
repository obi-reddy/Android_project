import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unexpiry/Components/custom_appbar.dart';
import 'package:unexpiry/Components/custom_heading_text.dart';
import 'package:unexpiry/screens/profile.dart';
import 'package:intl/intl.dart';

import '../apis/get_all_lists_by_month.dart';
import '../apis/get_expense.dart';
import '../apis/get_total_expense.dart';
import '../constants.dart';
class MonthlyExpenditure extends StatefulWidget {
  const MonthlyExpenditure({Key? key}) : super(key: key);

  @override
  State<MonthlyExpenditure> createState() => _MonthlyExpenditureState();
}
var wdth;
var hght;
class _MonthlyExpenditureState extends State<MonthlyExpenditure> {
  var selectedmonth;
  var selectindex=-1;
  List<dynamic> listex=[];
  List<dynamic>select=[];
  var totalex=0.0;

  List<dynamic> tatalexpense=[];
@override
  void initState() {
   getdata();
    super.initState();
  }
  Future<void>getdata()async{
  try {
    var tempdata=await get_all_lists_by_month();

    if(tempdata!=null){
      var map=tempdata as Map<dynamic,dynamic>;

    map.forEach((key, value) {
//print(DateTime.now().year-1);
      if(int.parse(key.substring(0,key.indexOf('-')))>=DateTime.now().year-1&&int.parse(key.substring(0,key.indexOf('-')))<=DateTime.now().year+1)
        listex.add({'key':key,'value':value,'isselect':false,'color':(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR});
    });}
  }catch(e){}finally{
    if(mounted)
      setState(() {

      });
  }
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
        backgroundColor: (THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,


      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:  StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('lists').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (context, snapshot) {
              totalex=0.0;
              List<dynamic> list=[];
              list.clear();
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              if(snapshot.hasData&&snapshot.data?.data()!=null){
                var map=snapshot.data?.data() as Map<dynamic,dynamic>;
                map.forEach((key, value) {
                  if(selectedmonth!=null&&key==selectedmonth)
                    list.add({'key': key, 'value': value});


                });}
            return ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                        children: [
                          if (index==0)
                            custom_heading_text("Monthly Expenditure"),
                          if (index==0)
                            SizedBox(height: hght/40,),
                          if (index==0)
                           Container(
                                width: wdth,
                                height: 20,

                                child:
                                    ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                        itemCount: listex.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context,indexhorizontal){
                                      return Row(children: [
                                        GestureDetector(
                                            onTap:(){
                                              selectedmonth=listex[indexhorizontal]['key'];

                                              for(int i=0;i<listex.length;i++){
                                                listex[i]['color']=(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR;
                                                listex[i]['select']=false;

                                              }
                                              listex[indexhorizontal]['color']=TEALISH_GREEN_COLOR;
                                              listex[indexhorizontal]['select']=false;

                                              setState(() {

                                              });

                                            },
                                            child: Container(
                                                color:listex[indexhorizontal]['color'],
                                                padding:EdgeInsets.all(2),
                                                child: Text(listex[indexhorizontal]['key'].substring(listex[indexhorizontal]['key'].indexOf('-')+1,listex[indexhorizontal]['key'].length),style: TextStyle(color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),))),
                                        SizedBox(width: 15,)
                                      ],);
                                    })

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
                                        Text("Date",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                      ],
                                    ),
                                    Text("List",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                    Text("Expenses",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),

                                  ],),
                                SizedBox(height: 4,),
                                Column(
                                  children: [
                                    ...list.map((e){return
                                      Column(
                                        children: [
                                          ...e['value'].map((e2){return
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
                                                        Text(DateFormat('dd-MM-yyy').format(e2['date'].toDate()),style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                                      ],
                                                    ),

                                                    Text("${e2['newname']!=null?e2['newname']:e2['listname']}",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                                    FutureBuilder(
                                                        future:get_total_expense(e['key']+e2['listname']+'ex'),
                                                        builder: (context,snap) {
                                                          return Text("${snap.data==null?"0.0":snap.data} SEK",style: TextStyle(fontSize: 16,color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),);
                                                        }
                                                    ),

                                                  ],),
                                                SizedBox(height: 4,),
                                              ],
                                            )
                                          ;})
                                          ,



                                        ],
                                      );
                                    })

                                  ],
                                ),

                              ],
                            ),




                          if(index==0)
                            SizedBox(height: hght/2,),
                          if(index==0&&selectedmonth!=null)
                          Row(
                            children: [

                              Container(
                                width: wdth/3,
                                height: hght/15,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text("Total Expenses",style: TextStyle(color:(THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                                ),
                              ),

                              SizedBox(
                                width: wdth/12,
                              ),
                              FutureBuilder(
                                            future:get_expense(list),
                                            builder: (context,snap) {
                                              print(snap.data);

                                            return Text("${snap.data==null?"0.0":snap.data} SEK",style: TextStyle(color: Colors.lightGreen,fontSize: 30,fontWeight: FontWeight.bold,),);
                                          }
                                    )

                            ],
                          ),



                        ],
                      );

                });
          }
        ),
      ),
    );
  }

}
