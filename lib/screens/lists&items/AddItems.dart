import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:unexpiry/Components/custom_button.dart';
import 'package:unexpiry/Components/custom_heading_text.dart';
import 'package:unexpiry/Components/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


import '../../apis/add_list_items.dart';
import '../../constants.dart';
class AddItems extends StatefulWidget {
  final group;
  final list;

  AddItems({this.group,this.list});

  @override
  State<AddItems> createState() => _AddItemsState();
}
var wdth;
var hght;
class _AddItemsState extends State<AddItems> {
  var selectedDate;
  var month='January';
 var name=TextEditingController();
 var price=TextEditingController();

  bool flg=false;

  Future<void> _selectDate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    // if (selected != null && selected != selectedDate) {
    selectedDate = selected!;
    if(mounted)
      setState(() {

      });
    //  }

  }
  @override
  Widget build(BuildContext context) {
    wdth=MediaQuery.of(context).size.width;
    hght=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:(THEME_MODE=='0')?BLACK_COLOR:WHITE_COLOR,

      appBar: AppBar(
        backgroundColor:(THEME_MODE=='1')?WHITE_COLOR:BLACK_COLOR,
        iconTheme: IconThemeData(
            color: Colors.lightGreen
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: hght/20,),
          custom_heading_text("Add item detail"),
          SizedBox(height: hght/20,),
          Container(
            padding: EdgeInsets.all(10),
            //color: Colors.red,
            width: wdth,
            height: hght/1.1,
            child: Column(
              children: [

                custom_textfield(hinttitle: "Name",controller: name,),
                SizedBox(height: hght/40,),
                GestureDetector(
                    onTap: () async {
                      datepicker();
                    },
                    child: custom_textfield(enable:false,hinttitle:selectedDate==null?'Expiry Date': DateFormat('yyy/MM/dd').format(selectedDate)),),
                SizedBox(height: hght/40,),
                custom_textfield(hinttitle: "Price",controller: price,type: TextInputType.number),
                SizedBox(height: hght/10,),
                custom_button(() async {
                  if(flg==true)return;
                  if(price.text.trim().isEmpty){
                    EasyLoading.showToast('price could not be empty!!');
                    return;
                  }
                  if(name.text.trim().isEmpty){
                    EasyLoading.showToast('name could not be empty!!');
                    return;
                  }
                  if(selectedDate==null){EasyLoading.showToast('please select date first !!');
                    return;
                  }


                 await add_list_items(listid: widget.group['key'],date:selectedDate,price:price.text,name: name.text,listname:widget.list['listname']);
                  flg=true;
                  setState(() {

                  });
                  Navigator.pop(context);
                }, "Add"),
              ],
            ),

          ),
        ],
      ),
    );
  }

  datepicker() {
    FocusManager.instance.primaryFocus?.unfocus();
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            child: StatefulBuilder(
                builder: (context,setState) {

                  DateTime now = new DateTime.now();
                  DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);

                  var lastday=lastDayOfMonth.day;
                  var lastmonth=lastDayOfMonth.month;
                  var lastyear=lastDayOfMonth.year;
                  print(lastmonth);
                  var mindate=DateTime.now();


// var hours=mindate.hour;
// var minutes=mindate.minute;
                  var day=mindate.day;
                  var year=mindate.year;
//var seconds=mindate.second;
                  var month=mindate.month;


                    // if(lastday==28&&day==28) {
                    //   day = 01;
                    //   if(month==12) {
                    //     month = 01;
                    //     year=year+1;
                    //   }
                    //   else
                    //     month=month+1;
                    //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                    //   lastday=lastDayOfMonth.day;
                    //   lastmonth=lastDayOfMonth.month;
                    //   lastyear=lastDayOfMonth.year;
                    //
                    // }
                    // else if(lastday==29&&day==29) {
                    //   day = 01;
                    //   if(month==12) {
                    //     month = 01;
                    //     year=year+1;
                    //   }
                    //   else
                    //     month=month+1;
                    //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                    //   lastday=lastDayOfMonth.day;
                    //   lastmonth=lastDayOfMonth.month;
                    //   lastyear=lastDayOfMonth.year;
                    //
                    // }
                    // else if(lastday==30&&day==30) {
                    //   day = 01;
                    //   if(month==12) {
                    //     month = 01;
                    //     year=year+1;
                    //   }
                    //   else
                    //     month=month+1;
                    //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                    //   lastday=lastDayOfMonth.day;
                    //   lastmonth=lastDayOfMonth.month;
                    //   lastyear=lastDayOfMonth.year;
                    //
                    // }
                    // else if(lastday==31&&day==31) {
                    //   day = 01;
                    //   if(month==12) {
                    //     month = 01;
                    //     year=year+1;
                    //   }
                    //   else
                    //     month=month+1;
                    //   lastDayOfMonth = new DateTime(year,month + 1, 0);
                    //   lastday=lastDayOfMonth.day;
                    //   lastmonth=lastDayOfMonth.month;
                    //   lastyear=lastDayOfMonth.year;
                    //
                    // }
                    // else
                    //
                    //   day=day+1;
                    //
                    //
                    //
                    //
                    //

//print(DateFormat('yy/MM/dd').format(mindate));

                  return SfDateRangePicker(

                    // enablePastDates:false,
                    enableMultiView:false,
                    onSelectionChanged: (value){
                      selectedDate=value.value;
                     setstatefun();
                      Navigator.pop(context);
                    },
                    view: DateRangePickerView.month,
                    // monthViewSettings: DateRangePickerMonthViewSettings(
                    //   weekendDays: <int>[1, 5],
                    // ),

                    minDate: DateTime(year, month,day, 0 , 0, 0),
                    maxDate: DateTime(2050, 01,01, 0 , 0, 0),
                  );
                }
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  void setstatefun() {
    setState((){});
  }
}
