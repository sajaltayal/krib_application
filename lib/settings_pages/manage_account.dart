import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:page_transition/page_transition.dart';

class ManageAccount extends StatefulWidget {
  final String currentUserId;
  ManageAccount({this.currentUserId});
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  @override
  void initState() { 
    super.initState();
    checkTypeAccount();
  }
  checkTypeAccount()async{
    await usersRef.document(widget.currentUserId).get().then((doc){
      if(doc.exists){
        if(doc["type"] == "public"){
        setState(() {
          type = "locked"; 
        });
      }
      }
    });
  }
  String type = "Unlocked";
  @override
  Widget build(BuildContext context) {
    List items = ["Edit Profile", "Switch to $type"];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 15,
        backgroundColor: Color(0xff1f1f1f),
        title: AutoSizeText("Manage account",style: TextStyle(color: Colors.white, letterSpacing: 1.5),),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1f1f1f),
              Color(0xff29323c),
              // Color(0xff414345),
              // Color(0xff414345),
            ]
          )
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, index){
                  return ListTile(
                    onTap: ()async{
                      if(items[index] == "Switch to Unlocked"){
                        usersRef.document(widget.currentUserId).updateData({
                          "type" : "public"
                        });
                        await activityFeedRef.document(widget.currentUserId).collection("usersFeed").where("type", isEqualTo: 'follow request').getDocuments().then((snapshot){
                          for(DocumentSnapshot doc in snapshot.documents){
                            if(doc.exists){
                            doc.reference.delete();
                          }
                          }
                        });
                        setState(() {
                          type = "locked";
                        });
                      }
                      if(items[index] == "Switch to locked"){
                        usersRef.document(widget.currentUserId).updateData({
                          "type" : "private"
                        });
                        setState(() {
                          type = "Unlocked";
                        });
                      }
                      if(items[index] == "Edit Profile"){
                        Navigator.push(context, PageTransition(child: ProfilePage1(isProfileOwner: true, isEditing: true, profileOfCurrentUserId: widget.currentUserId,), type: PageTransitionType.rightToLeftWithFade), );
                      }
                    },
                    trailing: items[index] == "Edit Profile" ? Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20,) : CupertinoSwitch(value: (type == "Unlocked"),onChanged: (val){
                      if(val){
                        setState(() {
                          type = "Unlocked";
                        });
                        usersRef.document(widget.currentUserId).updateData({
                          "type" : "private"
                        });
                      }
                      if(!val){
                        setState(() {
                          type = "locked";
                        });
                        usersRef.document(widget.currentUserId).updateData({
                          "type" : "public"
                        });
                        activityFeedRef.document(widget.currentUserId).collection("usersFeed").where("type", isEqualTo: 'follow request').getDocuments().then((snapshot){
                          for(DocumentSnapshot doc in snapshot.documents){
                            if(doc.exists){
                            doc.reference.delete();
                          }
                          }
                          });
                      }
                    },
                    //activeColor: Colors.purple,
                    //trackColor: Colors.yellowAccent,
                    ),
                    title: AutoSizeText(items[index], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
                  );
                }
                ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
              child: ListTile(
                onTap: (){
                  print("Account delete");
                },
                title: Text( "Delete Account",
                style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.red, size: 20,),
                      
              ),
            ),
          ],
        ),
      ),
    );
  }
}