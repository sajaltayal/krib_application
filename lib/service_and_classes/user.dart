import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String uid;
  String username;
  String phoneNo;
  String email;
  String fullName;
  String gender;
  String dob;
  String aadharNumber;
  String photoUrl;
  String type;
  String bio;
  String location;

  User({this.uid,this.location,this.username,this.type, this.phoneNo, this.email, this.fullName, this.gender, this.dob, this.aadharNumber, this.photoUrl, this.bio});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
    uid: doc['id'],
    type: doc['type'],
    username: doc['username'],
    phoneNo : doc['phoneNo'],
    email: doc['email'],
    fullName: doc['fullName'],
    gender : doc['gender'],
    dob : doc['dob'],
    aadharNumber : doc['aadharNumber'],
    photoUrl: doc['photoUrl'],
    bio: doc['bio'],
    location: doc['location'],
    );
  }
}


class ScreenArguments{
  String fullName;
  String dob;
  String gender;
  String aadharNumber;
  String email;
  String phoneNo;
  String username;
  String aadharUrl;
  String selfieUrl;

  ScreenArguments({this.fullName, this.aadharUrl, this.selfieUrl, this.dob, this.gender,this.aadharNumber,this.email, this.username,this.phoneNo});
}

class Visible{
  bool visiblity = true;
}
