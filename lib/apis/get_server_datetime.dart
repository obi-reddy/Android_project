import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<void> get_server_datetime()async{
  try {
   var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('users').doc(uid);
  var exist=await doc.get();
   if(exist.exists){
     await doc.update({"currentdatetime":FieldValue.serverTimestamp()});
   }
   var currenttime=await doc.get();
   return currenttime['currentdatetime']??DateTime.now();
  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}