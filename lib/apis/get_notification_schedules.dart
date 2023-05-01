import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<dynamic>get_notificaion_schedule()async{
  try{

    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc= FirebaseFirestore.instance.collection('listitems').doc(uid);
    var data=await doc.get();

    if(data.exists)
      {

        return data.data();
      }
    return null;
  }catch(e){}finally{}
}