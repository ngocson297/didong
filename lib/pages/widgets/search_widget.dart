import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  bool _sent;

  Future<bool> _isFriend() async{
    _sent = false;
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(g_User.uid)
        .get();
    List<dynamic> friends = doc.data()["friends"];
    print(widget.snapshot.id);
    if(friends.contains(widget.snapshot.id)) return true;
    _sent = await _isSent();
    return false;
  }

  Future<bool> _isSent() async{
    var snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('from',isEqualTo: g_User.uid)
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

  void _addFriend(String id) async{
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
      'from': g_User.uid,
      'to': id,
    }).then((value) {
      setState(() {
        _sent = true;
      });
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
                        child: Text(snapshot.data ? "Added" : _sent? "Sent" : "Request"),
                        onPressed: snapshot.data || _sent ? null : (){
                          _addFriend(widget.snapshot.id);
                        },
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){}
          );
        }
    );

  }
}