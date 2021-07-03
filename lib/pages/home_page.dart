import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/pages/friend_page.dart';
import 'package:flutter_chat_app/pages/menu_page.dart';
import 'package:flutter_chat_app/pages/request_page.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadAppKey();
    _registerNotification();
    _initLocalNotification();
  }

  DateTime _currentBackPressTime;

  void _loadAppKey(){
    var storageRef = FirebaseStorage.instance.ref();
    var giphyRef = storageRef.child('key/giphy_key.txt');
    giphyRef.getDownloadURL().then((url){
      http.get(Uri.parse(url)).then((value) {
        global_giphy_key = value.body.toString();
        print('GIPHY: '+ global_giphy_key);
      });
    });
  }

  void _registerNotification() {
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: '+ message.notification.title);
      _showNotification(message.notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: '+ message.notification.title);
    });

    _firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(global_User.uid)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void _showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.lttbdd.flutter_chat_app',
      'Flutter chat app',
      'description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
    );

    print(remoteNotification);

    await _flutterLocalNotificationsPlugin.show(
      123432,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  void _initLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          leading: InkWell(
            child: Padding(
              padding: EdgeInsets.all(6),
              child: CircleAvatar(backgroundImage: NetworkImage(global_User.imgUrl)),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
            },
          ),
          title: Text(global_User.username),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_rounded),
              iconSize: 32,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RequestPage()));
              },
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: TabBarView(
            children: const [
              ChatPage(),
              ChatPage(),
              FriendPage(),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.orangeAccent,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 4,
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.black12,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.message),
              text: "Chats",
            ),
            Tab(
              icon: Icon(Icons.people),
              text: "Friends",
            ),
          ],

        ),
      ),
    );
  }
}