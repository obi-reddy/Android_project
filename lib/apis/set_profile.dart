import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';
import 'upload_profile.dart';

Future<void> set_profile(file,image,name,age,phone,gender)async{
  try {
    EasyLoading.show();
    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('users').doc(uid);
   if(file!=null)
     image=await uploadImage(file);
    await doc.update({
     'name':name,
     'age':age,
     'gender':gender,
     'phone':phone,
      'image':image
   });
EasyLoading.showToast('successfully!!');
  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}