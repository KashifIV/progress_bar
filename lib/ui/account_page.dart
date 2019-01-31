import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget{
  final VoidCallback onSignedOut;
  AccountPage({this.onSignedOut});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(10),
            child: Text('Sign Out'),
            onPressed: onSignedOut,
          )
        ],
      )
    );
  }
}