import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/LogIn.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}
var wdth;
var hght;
class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: (){
        Get.offAll (()=>LogIn());
        },
        child: SingleChildScrollView(
          child:Center(
            child: Column(
              children: [
                SizedBox(height: hght/3.5,),
                Image.asset("images/Splash.png"),
              //  SizedBox(height:5,),
                Text("UnExpiry!",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
