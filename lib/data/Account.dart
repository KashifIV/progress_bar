import 'package:flutter/material.dart';

class Account{
  String id; 
  String profileImageURL; 
  String name; 
  String email; 
  Image profileImage; 
  String progressType; 
  List<String> joinedProjects; 
  Account({this.id, this.profileImageURL, this.name, this.email, this.joinedProjects, this.progressType}); 
  
  Map<String, dynamic> mapTo(){
    var dataMap = new Map<String, dynamic>(); 
    dataMap['name'] = this.name; 
    dataMap['profileImageURL'] = this.profileImageURL; 
    dataMap['email'] = this.email; 
    dataMap['joinedProjects'] = this.joinedProjects; 
    dataMap['progressType']  = this.progressType; 
    return dataMap; 
  }
  factory Account.fromMap(String id, Map<String, dynamic> map){
    return Account(
      id: id, 
      profileImageURL: map['profileImageURL'], 
      name: map['name'], 
      email: map['email'], 
      joinedProjects: (map.containsKey('joinedProjects'))? map['joinedProjects'].cast<String>() : [],
      progressType: (map.containsKey('progressType')) ? map['progressType'] : 'Task', 
    ); 
  }
}