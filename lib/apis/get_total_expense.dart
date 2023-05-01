import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<dynamic> get_total_expense(id,{totalflg=0})async{
  try {

    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc2= FirebaseFirestore.instance.collection('totalexpenditures').doc(uid);
    var total=await doc2.get();

    if(total.exists&&total.data()![id]!=null)
  return total.data()![id];
     return '0.0';
  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}