import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<void> remove_item({list,key,listname,lastprice})async{
  try {
    EasyLoading.show();
    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('listitems').doc(uid);

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


      var doc2= FirebaseFirestore.instance.collection('totalexpenditures').doc(uid);
      var total=await doc2.get();
      var last=double.parse(total.data()![listname].toString())-double.parse(lastprice);
      await doc2.update({'${listname}':last});
      last=double.parse(total.data()!['totalexpense'].toString())-double.parse(lastprice);
      if(last<0)
        last=0;
      await doc2.update({'${"totalexpense"}':last});
      last=double.parse(total.data()![key+'ex'].toString())-double.parse(lastprice);
      if(last<0)
        last=0;
      await doc2.update({'${key+'ex'}':last});


      EasyLoading.showToast('successfully deleted!!');

    });


  }catch(e){

  }finally{
    EasyLoading.dismiss();
  }
}