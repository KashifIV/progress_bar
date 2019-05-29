

import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/CRUD.dart';

class Log{
  String id; 
  DateTime dateWritten; 
  Account account; 
  String message; 
  Log({this.id, this.dateWritten, this.message, this.account}); 
  Map<String, dynamic> mapTo(){
    var dataMap = new Map<String, dynamic>(); 
    dataMap['date'] = dateWritten; 
    dataMap['accountID'] = account.id; 
    dataMap['message'] = message; 
    return dataMap; 
  }
  factory Log.fromMap(String id, Map<String, dynamic> map, Account account){
    return Log(id: id, account: account, message: map['message'], dateWritten: map['date']); 
  }
}