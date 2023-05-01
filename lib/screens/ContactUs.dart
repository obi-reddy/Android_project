import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:unexpiry/Components/custom_button.dart';
import 'package:unexpiry/Components/custom_textfield.dart';

import '../constants.dart';
class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}
var wdth;
var hght;
class _ContactUsState extends State<ContactUs> {
  var bodycontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR ,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: wdth/1.2,
            height: hght/1.5,
            child: Column(
              children: [
                Image.asset("images/contactarrow.png",width: wdth/3,height: hght/5,),
                Text("Contact Us",style: TextStyle(color: Colors.lightGreen,fontSize: 30,fontWeight: FontWeight.bold),),
                Container(
                  width: wdth/1.4,
                  child: Column(
                    children: [
                      Text("Write an email to us if you have any complaints or suggestions"
                          " which may help us to improve! We'll get back to"
                          " you as soon as we can :)",style: TextStyle(fontSize: 16,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR),textAlign:TextAlign.center),

                    ],
                  ),
                ),
                SizedBox(height: hght/60,),
                custom_textfield(hinttitle: "Add text",controller: bodycontroller,),
                SizedBox(height: hght/40,),
                custom_button(() async {
                 var email= Email(
                    body: bodycontroller.text,
                    recipients: ['unexpirycare@gmail.com'],
                    isHTML: false,
                  );
                   await FlutterEmailSender.send(email);
                   EasyLoading.showToast('successfully!!');
                }, "Send Massage"),
                Text("Thank you for reaching out!")

              ],
            ),
          ),
        ),
      ),
    );
  }
}
