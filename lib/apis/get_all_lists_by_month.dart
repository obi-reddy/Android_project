import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<dynamic> get_all_lists_by_month()async{
  try {

    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc2= FirebaseFirestore.instance.collection('lists').doc(uid);
    var total=await doc2.get();

    if(total.exists&&total.data()!=null)
      return total.data();
    return null;
  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}