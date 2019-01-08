import 'package:flutter/material.dart';
import 'data/auth.dart';
import 'package:progress_bar/ui/root_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/reducers.dart';
import 'package:progress_bar/domain/middleware.dart';
import 'package:redux/redux.dart';
import 'package:flutter/services.dart';

void main()
{
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
     final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [appStateMiddleware],
    );
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        
        title: 'Progress Bar',
        theme: new ThemeData(
          primarySwatch: Colors.pink
        ),
        home: StoreBuilder<AppState>(
          builder: (BuildContext context, Store<AppState> store)=>
            MyHomePage(store),
        )
      )
    );
  }
}

class MyHomePage extends StatelessWidget {
  Store<AppState> store;
  MyHomePage(this.store);
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Progress Bar',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: new RootPage(auth: new Auth())
    );
  }
}
