import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/ui/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/redux.dart';
class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final AuthImpl auth;
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_SIGNED_IN,
  SIGNED_IN,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  initState() {
    super.initState();
    widget.auth.getCurrentUser().then((userId) {
      setState(() {
          authStatus = userId == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SIGNED_IN;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_SIGNED_IN;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget CheckAuth(){
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
      case AuthStatus.NOT_SIGNED_IN:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.SIGNED_IN:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
      case AuthStatus.NOT_SIGNED_IN:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.SIGNED_IN:
        return HomePage(auth: widget.auth, onSignedOut: _signedOut);
        
    }
  }
}