import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<void> update_list({list,key})async{
  try {
    EasyLoading.show();
    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('lists').doc(uid);

    await doc.update({key:FieldValue.delete()}).whenComplete(() async {
      var exist=await doc.get();
      if(list.isNotEmpty) {
        if (!exist.exists)
          await doc.set({key:
          FieldValue.arrayUnion(list)
          });
        else
          await doc.update({key:
          FieldValue.arrayUnion(list)
          });
      }
      EasyLoading.showToast('successfully Updated!!');

    });


  }catch(e){

  }finally{
    EasyLoading.dismiss();
  }
}