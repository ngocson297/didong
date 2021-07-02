import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/ults/global.dart';

class SearchBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.black12
        ),
        child: Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10,),
            Text(
              "Search...",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchPage())
        );
      },
    );
  }
}

class SearchItem extends StatefulWidget{
  const SearchItem({Key key, this.snapshot}) : super(key: key);
  final QueryDocumentSnapshot snapshot;

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem>{

  bool _added;
  bool _sent;
  bool _received;

  var request;

  Future<bool> _isFriend() async{
    _sent = false;
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(global_User.uid)
        .get();
    List<dynamic> friends = doc.data()["friends"];
    if(friends.contains(widget.snapshot.id)) {
      _added = true;
      return true;
    }
    _sent = await _isSent();
    _received = await _isReceived();
    _added = false;
    return false;
  }

  Future<bool> _isSent() async{
    var snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('from',isEqualTo: global_User.uid)
        .get();
    if(snapshot.docs.isNotEmpty){
      for(var doc in snapshot.docs) {
        if (doc.get('to') == widget.snapshot.id) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> _isReceived() async{
    var snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('to',isEqualTo: global_User.uid)
        .get();
    if(snapshot.docs.isNotEmpty){
      for(var doc in snapshot.docs) {
        if (doc.get('from') == widget.snapshot.id) {
          request = doc;
          return true;
        }
      }
    }
    return false;
  }

  void _sendRequest(String id) async{
    _sent = await _isSent();
    if(_sent){
      setState(() {
        _sent = true;
      });
      return;
    }

    FirebaseFirestore.instance
        .collection('requests')
        .doc()
        .set({
      'from': global_User.uid,
      'to': id,
    }).then((value) {
      setState(() {
        _sent = true;
      });
    });
  }

  void _addFriend(String id) async{
    FirebaseFirestore.instance
        .collection('users')
        .doc(global_User.uid)
        .update({'friends': FieldValue.arrayUnion([id])});
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'friends': FieldValue.arrayUnion([global_User.uid])});

    FirebaseFirestore.instance
        .collection('requests')
        .doc(request.id).delete();
    setState(() {
      _added = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isFriend(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          return InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                ),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(widget.snapshot.get("imageUrl")), radius: 28,),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.snapshot.get("username"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        child: Text(_added ? "Added" : _sent? "Sent" : _received ? "Accept" : "Request"),
                        onPressed: _added || _sent ? null
                        : _received? (){
                          _addFriend(widget.snapshot.id);
                        } : (){
                          _sendRequest(widget.snapshot.id);
                        },
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(id: widget.snapshot.id)));
              }
          );
        }
    );

  }
}