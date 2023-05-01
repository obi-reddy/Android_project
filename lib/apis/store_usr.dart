import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';
import 'package:unexpiry/screens/home/homescreen.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<void> store_usr({required UserModel user,flg=0})async{
  try {
    var exist=await FirebaseFirestore.instance.collection('users').doc(user.id).get();
if(exist.exists&&flg==1)
  {
    Get.offAll(()=>homescreen());
    return;
  }
    await FirebaseFirestore.instance.collection('users').doc(user.id).set(
        user.tojson());
    if(flg==0)
    Get.to(()=>LogIn());
    else
      Get.offAll(()=>homescreen());
  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}