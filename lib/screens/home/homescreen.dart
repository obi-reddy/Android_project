import 'dart:async';

import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:unexpiry/Components/custom_button.dart';
import 'package:unexpiry/Components/custom_textfield.dart';
import 'package:unexpiry/constants.dart';
import '../../apis/number_of_day_schedule.dart';
import '../../apis/set_notify_onoff.dart';
import '../../apis/set_theme.dart';
import '../../apis/set_tone.dart';
import '../../models/Tones.dart';
import '../ContactUs.dart';
import 'package:unexpiry/apis/get_profile.dart';
import 'package:unexpiry/screens/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../Components/custom_appbar.dart';
import 'HomePage.dart';
import '../../fcmservices/fcmservices.dart';
class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}
var wdth;
var hght;

class _homescreenState extends State<homescreen> {
  @override
  String dropdownvalue = 'Theme   ';

  // List of items in our dropdown menu
  var items = [
    'Theme   ',
    'light(default)   ',
    'Dark   ',
  ];
  String dropdownvalue1 = 'Notification Tone   ';

  // List of items in our dropdown menu
  var items1 = [
    'Notification Tone   ',
    'Default   ',
    'Select from files   ',
  ];

  bool notifyflg=true;
  initState(){

    super.initState();
    intivar();
  }
  Timer? t;
  dispose(){
    t?.cancel();
    super.dispose();
  }
  intivar()async{
    try {
      t=Timer.periodic(Duration(seconds: 3), (timer) async {
        if(notifyflg){
          try {
            await get_profile();
            setState(() {

            });
           // await fcmservices.initNotifications();
           // await fcmservices.setSchedule();
            await fcmservices.initlocalnotificaionplugin();
            await fcmservices.shownotificaion();

            daycontroller.text =
            USER_PROFILE == null ? "3" : USER_PROFILE['schedule_day'] == null
                ? "3"
                : USER_PROFILE['schedule_day'];


            THEME_MODE =
            USER_PROFILE == null ? "1" : USER_PROFILE['theme'] == null
                ? "1"
                : USER_PROFILE['theme'];
            notifyflg = false;

          }catch(e){}finally{
            if (mounted)
              setState(() {

              });
          }

        }
      });


    }catch(e){}finally{
      if (mounted)
        setState(() {

        });
    }
  }
  var daycontroller=TextEditingController();
  bool status = false;
  Widget build(BuildContext context) {
    print(DateTime.now().toUtc());
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR ,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.lightGreen
      ),
        title:custom_appbar(),
        backgroundColor: (THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR,


      ),
      body: HomePage(),
      drawer: Drawer(
        backgroundColor:(THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.only(left: 20),
          children: [
            // const DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            //   child: Text('Drawer Header'),
            // ),
            SizedBox(height: hght/30,),
            ListTile(
              leading: Icon(
                Icons.arrow_back,
                color: Colors.lightGreen,
                size: 30,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 30,color:THEME_MODE=='0'?WHITE_COLOR:Colors.grey
              ),
              title:  Text('Settings',style: TextStyle(fontSize: 24,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              // leading: Icon(
              //   Icons.settings,
              //   size: 30,
              // ),
              title: Container(
                width: wdth/1.3,
                height: hght/15,
                decoration: BoxDecoration(
                  border:Border.all(color: Colors.lightGreen,width: 0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
dropdownColor: (THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR,
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon:  Icon(Icons.keyboard_arrow_down,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,style: TextStyle(color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR)),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) async {
                        if(newValue!.trim()=='light(default)')
                          THEME_MODE='1';
                        else if(newValue.trim()!='Theme'&&newValue.trim()=='Dark')
                          THEME_MODE='0';

                        setstatemethod();
                        print(newValue);
                          dropdownvalue = newValue;
                        await set_theme(THEME_MODE);
                        notifyflg=true;
                        setstatemethod();

                      },
                    ),
                  ],
                ),
              ),

              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: hght/30,),
            ListTile(
              
              title: Container(
                width: wdth/1.3,
                //color: Colors.red,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Default Reminder",style: TextStyle(fontSize: 20,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                      ],
                    ),
                    SizedBox(height: hght/60,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("Enter the number of days before which "
                          "you want to be notified about the expiry",style: TextStyle(fontSize: 14,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),
                      textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: hght/60,),
            ListTile(
              title: Row(
                children: [
                  Container(
                      width:MediaQuery.of(context).size.width/2,
                      child: custom_textfield(controller:daycontroller,hinttitle: "Enter the number here (default = 3)",type: TextInputType.number,)),
                Container(
                    width:MediaQuery.of(context).size.width/2.2/4,
                    child: custom_button(() async {
                      if(daycontroller.text.trim().isEmpty||daycontroller.text.trim()=='0'){
                        EasyLoading.showToast('Please enter any day first');
                        return;
                      }
                      var temp=daycontroller.text.replaceAll('.', '').toString().replaceAll(',', '').trim();
                      await number_of_day_schedule(temp);
                      Navigator.pop(context);
                      notifyflg=true;
                      if(mounted)
                        setState(() {

                        });
                    }, 'Set'))

                ],
              ),

            ),
            SizedBox(height: hght/60,),
            ListTile(

              title: Row(children: [
                Text('Notifications',style: TextStyle(fontSize: 24,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                SizedBox(width: wdth/8,),
                Center(
                  child: Container(
                    child: FlutterSwitch(
                      width: wdth/7.0,
                      height: 30.0,
                      valueFontSize: 25.0,
                      toggleSize: 20.0,
                      value: USER_PROFILE==null?status:(USER_PROFILE['notifyme']!=null)?USER_PROFILE['notifyme']:status,
                      borderRadius: 30.0,
                      padding: 8.0,
                      showOnOff: false,
                      activeColor: Colors.lightGreen,
                      inactiveColor: Colors.black38,
                      onToggle: (val) async {
                        setState(() {
                          status = val;
                        });
                        await set_notify_onoff(val);
                        notifyflg=true;
                        if(mounted)
                          setState(() {

                          });
                      },
                    ),
                  ),
                ),
              ],),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: hght/60,),
            ListTile(
              // leading: Icon(
              //   Icons.settings,
              //   size: 30,
              // ),
              title: Container(
                width: wdth/1.3,
                height: hght/15,
                decoration: BoxDecoration(
                  border:Border.all(color: Colors.lightGreen,width: 0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      dropdownColor: (THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,
                      // Initial Value
                      value: dropdownvalue1,

                      // Down Arrow Icon
                      icon:  Icon(Icons.keyboard_arrow_down,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,),

                      // Array list of items
                      items: items1.map((String items1) {
                        return DropdownMenuItem(
                          value: items1,
                          child: Text(items1,style: TextStyle(color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) async {
                        setState(() {
                          dropdownvalue1 = newValue!;
                        });
                        print(newValue);
                        if(newValue!.trim()=='Select from files')
                          customtones();
                         else if(newValue.trim()!='Notification Tone'&&newValue.trim()!='Select from files')
                         { await set_tone(null);
                          Navigator.pop(context);}
                        notifyflg=true;
                        if(mounted)
                          setState(() {

                          });
                      },
                    ),
                  ],
                ),
              ),

              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: hght/60,),
            ListTile(
              leading: Icon(
                Icons.sms,
                size: 30,color:THEME_MODE=='0'?WHITE_COLOR:Colors.grey
              ),
              title:  Text('Contact Us',style: TextStyle(fontSize: 24,color:(THEME_MODE=='0'?WHITE_COLOR:BLACK_COLOR)),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUs()));
              },
            ),
            SizedBox(height: hght/30,),
            custom_button((){
              showCustomDialog();
            },"Send an Email"),

          ],
        ),
      ),
    );

  }


  void showCustomDialog() {
    var subject=TextEditingController();
    var body=TextEditingController();
    var cc=TextEditingController();
    var bcc=TextEditingController();
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: BLACK_COLOR.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            color: (THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,
            height: MediaQuery.of(context).size.height/2,
            padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: SizedBox.expand(child:
            Column(children: [
              custom_textfield(hinttitle: 'subject',controller: subject,),
              SizedBox(height: 10,),
              custom_textfield(hinttitle: 'body',controller: body,),
              SizedBox(height: 10,),
              custom_textfield(hinttitle: 'cc',controller: cc,),
              SizedBox(height: 10,),
              custom_textfield(hinttitle: 'bcc',controller: bcc,),
              SizedBox(height: 10,),
              custom_button(() async {
                try {
                  print("jjffjf");
                  final Email email = Email(
                    body: body.text,
                    subject: subject.text,
                    recipients: ['unexpirycare@gmail.com'],
                    cc: [cc.text],
                    bcc: [bcc.text],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email);
                  EasyLoading.showToast('email have been sent!!');
                }catch(e){
                  print(e);
                }finally{
                  EasyLoading.dismiss();
                }
              }, 'Send')
            ],)
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
  }

  void customtones() {
List<Tones> toneslist=[
     Tones(name:'cute notify',path: 'cute_notification'),
     Tones(name:'knock',path: 'knock_knock'),
     Tones(name:'nofify1',path: 'notifacation'),
     Tones(name:'nofify2',path: 'notification_sound'),
     Tones(name:'nofify3',path: 'notification_sound2'),
     Tones(name:'sms',path: 'sms'),
     Tones(name:'call',path: 'tone2'),
     Tones(name:'song',path: 'testting'),
];
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor:BLACK_COLOR.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            color:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,
            height: MediaQuery.of(context).size.height/2,
            padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: SizedBox.expand(child:
           ListView.builder(
               itemCount: toneslist.length,
               shrinkWrap: true,
               itemBuilder: (context,index){
             return Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,

                   children: [
                   Icon(Icons.audiotrack,color: Colors.red,),
                   Text(toneslist[index].name!,style: TextStyle(color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR)),
                     Spacer(),
                     Container(
                         width: 60,
                         height: 20,
                         child: custom_button(() async {
                           await set_tone(toneslist[index].path);
                           Navigator.pop(context);
                           notifyflg=true;
                           if(mounted)
                             setState(() {

                             });
                         }, 'Select'))
                 ],),
                 SizedBox(height: 10,)
               ],
             );
           })
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
  }

  void setstatemethod() {
    setState(() {

    });
  }
}
