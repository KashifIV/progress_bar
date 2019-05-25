import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
class AccountPage extends StatelessWidget{
  final VoidCallback onSignedOut;
  final Auth auth; 
  AccountPage({this.auth,this.onSignedOut});
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: ListView(
          children: <Widget>[
            SizedBox(height: 40,), 
            Icon(
              Icons.account_circle, 
              size: 100,
              color: Colors.blue,
              ), 
            Center(
              child: Text(
                (model.account.name == null) ? 'Username': model.account.name, 
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 32,
                ),
              ),
            ),
            Center(
              child: Text(
                (model.account.email == null)? 'Email' : model.account.email,
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 20
                ),
              )
            ), 
            SizedBox(height: 20,),
            FlatButton(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue,
                child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 15
                ),
              )),
              onPressed: () {
                onSignedOut(); 
                Navigator.pop(context);
              }
            )
          ],
        )))
      )
    ));
  }
}