import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../screens/profile.dart';

class custom_appbar extends StatefulWidget {
  const custom_appbar({Key? key}) : super(key: key);

  @override
  State<custom_appbar> createState() => _custom_appbarState();
}

class _custom_appbarState extends State<custom_appbar> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 0.5,),
        Text("UnExpiry!",style: TextStyle(color: Colors.lightGreen,fontSize: 24,fontWeight: FontWeight.bold),),

        GestureDetector(
          onTap: (){
           Get.to(()=>profile());
          },
          child: CircleAvatar(

              child:  ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                    USER_PROFILE==null?"":USER_PROFILE['image']??"",
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return
                        Image.asset("images/profile.jpg",

                        );
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes !=
                              null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),);}),
              )

            //AssetImage("images/profile.jpg"),
          ),
        ),
      ],
    );
  }
}
