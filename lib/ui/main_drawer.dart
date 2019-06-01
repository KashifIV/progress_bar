import 'package:flutter/material.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/ui/account_page.dart';
import 'package:progress_bar/ui/calendar_page.dart';

class MainDrawer extends StatelessWidget{
  final String name;
  final Auth auth;  
  final VoidCallback onSignedOut; 
  MainDrawer(this.name, {this.auth, this.onSignedOut});
  List<String> titles = ['Profile', 'Calendar','Settings']; 
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue
            ),
            child: Container(
              child: Row(
                
                children: <Widget>[
                Icon(Icons.account_circle) ,
                Text(name),
              ],),
            )
          ), 
          ListTile(
            title: Text(titles[0]),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage(onSignedOut: onSignedOut,))); 
            }
          ), 
          ListTile(
            title: Text(titles[1]),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarPage()));
            }
          ),
          ListTile(
            title: Text(titles[2]),
          )
        ],
      ),
    );
  }
}