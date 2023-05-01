import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<void> add_list({date,name,listid,callback,year})async{
  try {
    EasyLoading.show();
debugPrint(listid);
   var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('lists').doc(uid);
    var exist=await doc.get();
    if(!exist.exists)
           await doc.set({year.toString()+'-'+listid:
             FieldValue.arrayUnion([{
               'listname': name,
               'date': date,
               'groupid': year.toString()+listid,

           }])
           });
    else
      await doc.update({year.toString()+'-'+listid:
      FieldValue.arrayUnion([{
        'listname': name,
        'date': date,
        'groupid': year.toString()+listid,

      }])
      });

    callback();
         EasyLoading.showToast('successfully add new list');

  }catch(e){
    print(listid);
  }finally{
    EasyLoading.dismiss();
  }
}