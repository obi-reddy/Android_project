import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unexpiry/Components/custom_button.dart';
import 'package:unexpiry/Components/custom_textfield.dart';
import 'package:unexpiry/Components/passwordtextfield.dart';
import 'package:unexpiry/apis/auth/Authentication.dart';
import 'package:unexpiry/screens/home/homescreen.dart';

import '../../Components/custom_heading_text.dart';
import '../../models/UserModel.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}
var wdth;
var hght;
class _SignUpState extends State<SignUp> {
  var email=TextEditingController();
  var name=TextEditingController();
  var ph=TextEditingController();
  var age=TextEditingController();
  var gender=TextEditingController();
  var password=TextEditingController();
  List<String>wrongrext=[
    "","","","","",""
  ];
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: hght/9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custom_heading_text("Welcome to UnExpiry"),
                  ],
                ),
                SizedBox(height: hght/20,),
                Row(
                  children: [
                    Text("Name",style: TextStyle(fontSize: 16),),
                  ],
                ),
                custom_textfield(hinttitle: "Type your name here",controller: name,),
                if(wrongrext[0].isNotEmpty)
                  Text(wrongrext[0],style: TextStyle(color: Colors.red),),
                SizedBox(height: hght/60,),
                Row(
                  children: [
                    Text("Age",style: TextStyle(fontSize: 16),),
                  ],
                ),
                custom_textfield(hinttitle: "Type your age here",controller: age),
                if(wrongrext[1].isNotEmpty)
                  Text(wrongrext[1],style: TextStyle(color: Colors.red),),
                SizedBox(height: hght/60,),
                Row(
                  children: [
                    Text("Gender",style: TextStyle(fontSize: 16),),
                  ],
                ),
                custom_textfield(hinttitle: "Type your gender here",controller: gender,),
                if(wrongrext[2].isNotEmpty)
                  Text(wrongrext[2],style: TextStyle(color: Colors.red),),
                SizedBox(height: hght/60,),
                Row(
                  children: [
                    Text("Mail ID",style: TextStyle(fontSize: 16),),
                  ],
                ),
                custom_textfield(hinttitle: "Type your mail ID here",controller: email,type: TextInputType.emailAddress),
                if(wrongrext[3].isNotEmpty)
                  Text(wrongrext[3],style: TextStyle(color: Colors.red),),
                SizedBox(height: hght/60,),
                Row(
                  children: [
                    Text("Phone Number",style: TextStyle(fontSize: 16),),
                  ],
                ),
                custom_textfield(hinttitle: "Type your phone number here",controller: ph,type: TextInputType.phone),
                if(wrongrext[4].isNotEmpty)
                  Text(wrongrext[4],style: TextStyle(color: Colors.red),),
                SizedBox(height: hght/60,),
                Row(
                  children: [
                    Text("Password",style: TextStyle(fontSize: 16),),
                  ],
                ),
                custom_textfield(hinttitle: "Type your password here",controller: password,obsecure: true,),
                if(wrongrext[5].isNotEmpty)
                  Text(wrongrext[5],style: TextStyle(color: Colors.red),),
                SizedBox(height: hght/40,),

              custom_button(() async {
                try{
                for(int i=0;i<wrongrext.length;i++){
                  wrongrext[i]='';
                  setState(() {

                  });
                }
                  var phflg=GetUtils.isPhoneNumber(ph.text);
                  if(name.text.trim().isEmpty){
                    wrongrext[0]='Name couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(age.text.trim().isEmpty){
                    wrongrext[1]='Age couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(gender.text.trim().isEmpty){
                    wrongrext[2]='Gender couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(!email.text.trim().isEmail){
                    wrongrext[3]='Not a email!!';
                    setState(() {

                    });
                    return;
                  }
                  if(email.text.trim().isEmpty){
                    wrongrext[3]='Mail ID couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(!phflg){
                    wrongrext[4]='Not a phone number!!';
                    setState(() {

                    });
                    return;
                  }
                  if(ph.text.trim().isEmpty){
                    wrongrext[4]='Phone number couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(password.text.trim().isEmpty){
                    wrongrext[5]='Password couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                if(password.text.trim().length<6){
                  wrongrext[5]='Password should be 6 characters!!';
                  setState(() {

                  });
                  return;
                }
                  await Authentication.Registration(usermodel: new UserModel(email:email.text,password: password.text,name: name.text,gender:gender.text,age:age.text,ph: ph.text));
                }catch(e){}finally{}

                }, "Sign Up"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
