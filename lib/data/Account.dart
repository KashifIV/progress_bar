import 'package:flutter/material.dart';

class Account{
  String id; 
  String profileImageURL; 
  String name; 
  String email; 
  Image profileImage; 
  Account({this.id, this.profileImageURL, this.name, this.email}); 
  
  Map<String, dynamic> mapTo(){
    var dataMap = new Map<String, dynamic>(); 
    dataMap['name'] = this.name; 
    dataMap['profileImageURL'] = this.profileImageURL; 
    dataMap['email'] = this.email; 
    return dataMap; 
  }
  factory Account.fromMap(String id, Map<String, dynamic> map){
    return Account(id: id, profileImageURL: map['profileImageURL'], name: map['name'], email: map['email']); 
  }
}