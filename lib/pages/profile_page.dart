import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key key}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(),
//     body: Center(),
//   );
// }
// }

class ProfilePage extends StatelessWidget {
  final String name;

  const ProfilePage({
    @required this.name,
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Edit Username',
                      hintText: 'Enter Edit',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Edit Password',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Edit Email',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'FirstName',
                      hintText: 'Enter Edit FirstName',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'LastName',
                      hintText: 'Enter Edit LastName',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                      hintText: 'Enter Edit Your Phone',
                    ),
                  ),
                ),

                ElevatedButton(
                    child: ElevatedButton(
                      child: Text('Update'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                  ),
                  ),
              ],
            )
        )
    );
  }
}

