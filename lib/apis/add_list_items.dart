import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../fcmservices/fcmservices.dart';

Future<void> add_list_items({date,name,listid,price,listname})async{
  try {
    EasyLoading.show();
    var rng = Random();
    int id = rng.nextInt(50000) + DateTime
        .now()
        .millisecond;
var itemname=listid+listname;
    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('listitems').doc(uid);
    var exists=await doc.get();
    if(exists.exists){
      await doc.update({itemname:FieldValue.arrayUnion([{
      'itemname': name,
      'expirydate': date,
      'listid': listid,
      'price': price,
      'notifyid': id,

    }])});

    }
    else
      await doc.set({itemname:FieldValue.arrayUnion([{
        'itemname': name,
        'expirydate': date,
        'listid': listid,
        'price': price,
        'notifyid': id,

      }])});
    var doc2= FirebaseFirestore.instance.collection('totalexpenditures').doc(uid);
       var total=await doc2.get();

       if(total.exists&&total.data()!['${itemname+"ex"}']!=null){
         await doc2.update({'${itemname+"ex"}':double.parse(total.data()!['${itemname+"ex"}'].toString())+double.parse(price)});
       }
       else{
         if(total.exists)
           await doc2.update({itemname + "ex": price});
         else
           await doc2.set({itemname + "ex": price});


       }
    if(total.exists&&total.data()![listid]!=null)
      await doc2.update({'${listid}':double.parse(total.data()!['${listid}'].toString())+double.parse(price)});
    else
      await doc2.update({listid: price});

       if(total.exists&&total.data()!['totalexpense']!=null)
         await doc2.update({'${"totalexpense"}':double.parse(total.data()!['${"totalexpense"}'].toString())+double.parse(price)});
          else
         await doc2.update({'totalexpense': price});
    EasyLoading.showToast('successfully add new Item');
   // await fcmservices.setSchedule();
    await fcmservices.initlocalnotificaionplugin();
    await fcmservices.shownotificaion();

  }catch(e){
    print(listid);
  }finally{
    EasyLoading.dismiss();
  }
}