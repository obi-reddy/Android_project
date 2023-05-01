import 'dart:developer';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:unexpiry/constants.dart';
import '../apis/get_notification_schedules.dart';

class fcmservices {
  // static Future<void> supscribetotopic({topic})async{
  //   await FirebaseMessaging.instance.subscribeToTopic(topic);
  //
  //
  //
  // }
  static late var flutterNotificationPlugin;
  static Future<void> initNotifications() async {
//
// if(USER_PROFILE!=null&&USER_PROFILE['tone']!=null)
//     AwesomeNotifications().initialize(
//        null,
//         [
//             NotificationChannel(
//               channelGroupKey: 'notification_channel',
//               channelKey: 'notification_channel',
//               channelName: 'notification_channel',
//               channelDescription: 'Item Expiry Alert !!',
//               channelShowBadge: true,
//               importance: NotificationImportance.High,
//               locked: false,
//               defaultRingtoneType: DefaultRingtoneType.Notification,
//               // enableVibration: true,
//               playSound: true,
//                soundSource: 'resource://raw/${USER_PROFILE['tone']}',
//
//               ),
//         ],
//         channelGroups: [
//           NotificationChannelGroup(
//             channelGroupKey: 'notification_channel',
//             channelGroupName: 'notification_channel',
//           ),
//         ],
//         debug: true);
// else
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Item Expiry Alert !!',
          channelShowBadge: true,
          importance: NotificationImportance.High,
         // locked: false,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableVibration: true,
          playSound: true,


        ),
      ],

      debug: true);
  }

  // static Future<void> showFlutterNotification(RemoteMessage message) async {
  //
  //   var  notification = message.data;
  //   if (message.notification != null) {
  //    // await SharedPrefrenceUserlogin.isbackgrounornot(true);
  //     fcmservices.onSelectNotification(notification);
  //
  //   }
  // }
  // static Future<void>  firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   print('Handling a background message');
  //   await Firebase.initializeApp();
  //   await fcmservices.setupFlutterNotifications();
  //   await fcmservices.showFlutterNotification(message);
  //
  // }
  // static Future<void>initvariables()async{
  //
  //
  //    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //      print('Got a message whilst in the foreground!');
  //
  //
  //
  //      if (message.notification != null) {
  //        fcmservices.onSelectNotification(message.data);
  //
  //      }
  //    });
  //    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //
  //      if (message.notification != null)
  //
  //      fcmservices.onSelectNotification(message.data);
  //    //  flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  //
  //    });
  //    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
  //
  //      if(message!=null)
  //        fcmservices.onSelectNotification(message.data);
  //      //  flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  //
  //    });
  //
  //
  //    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //      alert: false,
  //      badge: true,
  //      sound: false,
  //    );
  //  }

  static setSchedule() async {
    var data = await get_notificaion_schedule();

    if (data != null&&USER_PROFILE!=null&&USER_PROFILE['notifyme']!=null&&USER_PROFILE['notifyme']) {
      var map = data as Map<dynamic, dynamic>;
   var duration=3;
   if(USER_PROFILE['schedule_day']!=null)
     duration=int.parse(USER_PROFILE['schedule_day'].toString());

      map.forEach((key, value) {
        if (int.parse(key.substring(0, key.indexOf('-')))>=
            DateTime.now().year) {

          for (int i = 0; i < value.length; i++) {


            final DateTime expirydate =
            (value[i]['expirydate'].toDate()) .toUtc();

            final DateTime _dateTimeInUtc =
            expirydate.subtract(Duration(days: duration));
       // if(USER_PROFILE!=null&&USER_PROFILE['tone']!=null)
       //      new AwesomeNotifications().createNotification(
       //          content: NotificationContent(
       //            id: 1,
       //            body:
       //                'Item(${value[i]['itemname']}) going to expire at this date ${DateFormat('dd-MM-yyy hh:mm:ss a').format(value[i]['expirydate'].toDate())}',
       //            title: 'Item expire alert!!',
       //            channelKey: 'notification_channel',
       //            groupKey: 'notification_channel',
       //            autoDismissible: true,
       //            fullScreenIntent: true,
       //           customSound:'resource://raw/${USER_PROFILE['tone']}'
       //          ),
       //          schedule: NotificationCalendar.fromDate(date: _dateTimeInUtc));
       // else
         new AwesomeNotifications().createNotification(
             content: NotificationContent(
                 id: 1,
                 body:
                 'Item(${value[i]['itemname']}) going to expire at this date ${DateFormat('dd-MM-yyy hh:mm:ss a').format(value[i]['expirydate'].toDate())}',
                 title: 'Item expire alert!!',
                   channelKey: 'alerts',
                 autoDismissible: true,
                 fullScreenIntent: true,
             ),
             schedule: NotificationCalendar.fromDate(date: _dateTimeInUtc));
          }
        }
      });
    }
    else
    AwesomeNotifications().cancelAllSchedules();
  }
  static initlocalnotificaionplugin()async{
     flutterNotificationPlugin= FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: null);

    await flutterNotificationPlugin.initialize(initializationSettings);



}
static shownotificaion()async{

  //  UriAndroidNotificationSound uriSound =
  // UriAndroidNotificationSound('');
  var data = await get_notificaion_schedule();

  if (data != null&&USER_PROFILE!=null&&USER_PROFILE['notifyme']!=null&&USER_PROFILE['notifyme']) {
    var map = data as Map<dynamic, dynamic>;
    var duration=3;
    if(USER_PROFILE['schedule_day']!=null)
      duration=int.parse(USER_PROFILE['schedule_day'].toString());

    map.forEach((key, value) async {
      if (int.parse(key.substring(0, key.indexOf('-')))>=
          DateTime.now().year) {

        for (int i = 0; i < value.length; i++) {
          final DateTime expirydate =
          (value[i]['expirydate'].toDate());
          var _dateTimeInUtc =expirydate.subtract(Duration(days: duration));
          var id = int.parse(value[i]['notifyid'].toString());
          print("*********************************");

          if (_dateTimeInUtc.millisecondsSinceEpoch>DateTime
              .now()
              .millisecondsSinceEpoch) {

            AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
                '$id',
                "schedule",
                //sound:  UriAndroidNotificationSound('resource://raw/testting'),
                channelDescription: 'Item(${value[i]['itemname']}) going to expire at this date ${DateFormat(
                    'dd-MM-yyy hh:mm:ss a').format(
                    value[i]['expirydate'].toDate())}',

                importance: Importance.high,
                priority: Priority.high,
                playSound: true,
                enableVibration: true,
                fullScreenIntent: true
            );
            DarwinNotificationDetails darwinNotificationDetails =
            DarwinNotificationDetails(presentSound: false);
            NotificationDetails notificationDetails = NotificationDetails(
              android: androidPlatformChannelSpecifics,
              iOS: darwinNotificationDetails,
            );

            print("************************");
            print(_dateTimeInUtc);
            print(DateTime.now().subtract(Duration(seconds: 5)));
            print("************************");
            // var scheduledNotificationDateTime =
            // DateTime.now().add(Duration(seconds: 5));
            await flutterNotificationPlugin.schedule(
                id,
                'Item expire alert!!',
                'Item(${value[i]['itemname']}) going to expire at this date ${DateFormat(
                    'dd-MM-yyy hh:mm:ss a').format(
                    value[i]['expirydate'].toDate())}',

                _dateTimeInUtc,
                notificationDetails);
            // if(USER_PROFILE!=null&&USER_PROFILE['tone']!=null)
            //      new AwesomeNotifications().createNotification(
            //          content: NotificationContent(
            //            id: 1,
            //            body:
            //                'Item(${value[i]['itemname']}) going to expire at this date ${DateFormat('dd-MM-yyy hh:mm:ss a').format(value[i]['expirydate'].toDate())}',
            //            title: 'Item expire alert!!',
            //            channelKey: 'notification_channel',
            //            groupKey: 'notification_channel',
            //            autoDismissible: true,
            //            fullScreenIntent: true,
            //           customSound:'resource://raw/${USER_PROFILE['tone']}'
            //          ),
            //          schedule: NotificationCalendar.fromDate(date: _dateTimeInUtc));
            // else

         }
          else if(expirydate.millisecondsSinceEpoch<DateTime.now().millisecondsSinceEpoch) {
            await flutterNotificationPlugin.cancel(id);
            print("end");
          }
        }
      }
    });
  }
else if(USER_PROFILE['notifyme']!=null&&USER_PROFILE['notifyme']==false)
  await flutterNotificationPlugin.cancelAll();
  // await flutterNotificationPlugin.show(
  //       '0',
  //     "A Notification From My Application",
  //     "This notification was sent using Flutter Local Notifcations Package",
  //     notificationDetails,
  //     payload: 'data',);

}

}
