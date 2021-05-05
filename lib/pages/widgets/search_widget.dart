import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/search_page.dart';

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
              "Search",
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