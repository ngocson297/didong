import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/widgets/request_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> with TickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this,);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _requestListBuild({bool receive = false}){
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: receive? FirebaseFirestore.instance
                .collection('requests')
                .where('to',isEqualTo: global_User.uid).snapshots()
                : FirebaseFirestore.instance
                .collection('requests')
                .where('from',isEqualTo: global_User.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return ListView(
                  children: snapshot.data.docs
                      .map<Widget>((request){
                    return RequestItem(snapshot: request, receive: receive);
                  }).toList()
              );
            },
          ),
        ),
      ],
    )
      ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Requests"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Recieved"
            ),
            Tab(
              text: "Sent",
            ),
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _requestListBuild(receive: true),
          _requestListBuild(),
        ],
      ),
    );
  }
}
