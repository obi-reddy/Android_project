import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unexpiry/screens/home/HomePage.dart';

import '../screens/auth/LogIn.dart';
import '../models/UserModel.dart';

Future<dynamic> get_expense(list)async{
  try {

    var uid= FirebaseAuth.instance.currentUser?.uid;
    var doc2= FirebaseFirestore.instance.collection('totalexpenditures').doc(uid);
    var total=await doc2.get();
var totalex=0.0;
    if(total.exists&&total.data()!=null){
      var map=total.data() as Map<dynamic,dynamic>;

     for(int i=0;i<list.length;i++){
       for(int j=0;j<list[i]['value'].length;j++){
        // print(map[(list[i]['key']+map[i]['value'][j]['listname']+'ex')]);

         totalex=totalex+double.parse(map[(list[i]['key']+list[i]['value'][j]['listname']+'ex')].toString());

       }

     }
    }
      return totalex;

  }catch(e){}finally{
    EasyLoading.dismiss();
  }
}