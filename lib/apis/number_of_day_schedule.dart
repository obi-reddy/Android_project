
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../fcmservices/fcmservices.dart';


Future<void> number_of_day_schedule
    (value)async{
  try {

    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('users').doc(uid);

    await doc.update({
      'schedule_day':value,
    });
      EasyLoading.showToast('Notification will be come $value days before expire any item date');
    await fcmservices.initlocalnotificaionplugin();
    await fcmservices.shownotificaion();
  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}