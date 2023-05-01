import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/Components/custom_button.dart';
import 'package:unexpiry/Components/custom_heading_text.dart';
import 'package:unexpiry/Components/custom_textfield.dart';
import 'package:unexpiry/Components/passwordtextfield.dart';
import 'package:unexpiry/screens/auth/ForgotPassword.dart';
import '../../constants.dart';
import 'SignUp.dart';

import '../../apis/auth/Authentication.dart';
class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}
var wdth;
var hght;
class _LogInState extends State<LogIn> {
  var email=TextEditingController();
  var password=TextEditingController();
  List<String>wrongrext=[
    "",""
  ];
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      body:SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: hght/7,),
              custom_heading_text("Welcome to UnExpiry"),
              SizedBox(height: hght/7,),
              Row(

                children: [
                  Text("Sign in",style: TextStyle(fontSize: 16),),
                ],
              ),
              SizedBox(height: hght/60,),
              custom_textfield(hinttitle: "Mail Id",controller: email,type: TextInputType.emailAddress),
              if(wrongrext[0].isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(wrongrext[0],style: TextStyle(color: Colors.red),),
                  ],
                ),

              SizedBox(height: hght/60,),
              custom_textfield(hinttitle: "password",controller: password,obsecure: true,),

              if(wrongrext[1].isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Text(wrongrext[1],style: TextStyle(color: Colors.red),),
                  ],
                ),
              SizedBox(height: hght/60,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                },
                child: Row(
                  children: [
                    Text("Forgot Password?",style: TextStyle(fontSize: 16,color: Colors.lightGreen,fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
              SizedBox(height: hght/60,),
              custom_button(() async {
                try{
                  for(int i=0;i<wrongrext.length;i++){
                    wrongrext[i]='';
                    setState(() {

                    });
                  }
                  if(!email.text.trim().isEmail){
                    wrongrext[0]='Not a email!!';
                    setState(() {

                    });
                    return;
                  }
                  if(email.text.trim().isEmpty){
                    wrongrext[0]='Mail ID couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(password.text.trim().isEmpty){
                    wrongrext[1]='Password couldn\'t be empty!!';
                    setState(() {

                    });
                    return;
                  }
                  if(password.text.trim().length<6){
                    wrongrext[1]='Password should be 6 characters!!';
                    setState(() {

                    });
                    return;
                  }
                  await Authentication.LoginWithEmail(email:email.text,password: password.text);
                }catch(e){}finally{
                  EasyLoading.dismiss();
                }
              }, "Log In"),
              SizedBox(height: hght/60,),
              Row(
                children: [
                  Text("New user?",style: TextStyle(fontSize: 16,color: (THEME_MODE=='0')?WHITE_COLOR:BLACK_COLOR,fontWeight: FontWeight.w400),),
                ],
              ),
              SizedBox(height: hght/60,),
              custom_button((){
                Get.to(()=>SignUp());
                }, "Sign Up"),
              SizedBox(height: hght/30,),
              Row(children: [
                SizedBox(width: wdth/30,),
                Image.asset("images/google.jpg",width: 50,height: 50,),
              GestureDetector(
            onTap:() async {
              try{
                EasyLoading.show();
               await Authentication.signInWithGoogle();
              }catch(e){}finally{
                EasyLoading.dismiss();
              }
            },
                child: Container(
              width:wdth/ 1.4,
              height: hght/16,
              decoration: BoxDecoration(
                //color:Colors.lightGreen,
                borderRadius:BorderRadius.circular(5),
                  border: Border.all(color: Colors.lightGreen,width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign in with Google",style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.w700,fontSize: 16),)
                ],
              ),
            ),
          ),
              ],)

            ],
          ),
        ),
      ),
      ) ,
    );

  }
}
