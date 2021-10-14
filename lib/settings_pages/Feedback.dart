import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class FeedBack extends StatefulWidget {
  final String currentUserId;
  FeedBack({this.currentUserId});

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
String email;
  String phoneNo;
  String feedback;
  int rating;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int randomNo = Random().nextInt(100000000);
  final DateTime timestamp = DateTime.now();
 
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     key: _scaffoldKey,
     appBar: AppBar(
       centerTitle: true,
        elevation: 15,
        backgroundColor: Color(0xff1f1f1f),
        title: AutoSizeText("Feedback",style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontFamily: "Helvetica"),),
     ),
     body: FutureBuilder(
       future: usersRef.document(widget.currentUserId).get(),
       builder: (context, snapshot) {
         if(!snapshot.hasData){
           return Container(
             height: double.maxFinite,
             width: double.maxFinite,
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
             child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
          )), ),
           );
         }
        User user = User.fromDocument(snapshot.data);
        return Center(
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
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
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(user.username, style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        
                      ),
                      textAlign: TextAlign.start,),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                        child: RatingBar.builder(
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              this.rating = rating.toInt();
                            });
                            print(rating);
                          },
                          ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            //controller: phoneController,
                            onSaved: (val){
                            setState(() {
                              this.phoneNo = val;
                            });
                          },
                            initialValue: user.phoneNo,
                            maxLength: 10,
                            
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white, 
                              fontFamily: "Helvetica",
                              
                              ),
                            cursorColor: Colors.white,
                            validator: (val){
                              return val.length < 10 ? "Please enter a valid mobile number" : null;
                            },
                            decoration: InputDecoration(
                              hintText: "Mobile Number",
                              hintStyle: TextStyle(
                                fontFamily: "Helvetica", 
                                color: Colors.white,
                                
                                ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                                ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                                ),
                              
                            ),
                            
                          )
                          ),
                      ),
                        Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            //controller: emailController,
                            
                            validator: (val){
                              return val.toString() == user.email ? null : "This email ID does not matches";
                            },
                            onSaved: (val){
                            setState(() {
                              this.email = val.toString();
                            });
                          },
                            initialValue: user.email,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(
                              color: Colors.white, 
                              fontFamily: "Helvetica",
                              
                              ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "Email ID",
                              hintStyle: TextStyle(
                                fontFamily: "Helvetica", 
                                color: Colors.white,
                                ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                                ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                                ),
                              
                            ),
                            
                          )
                          ),
                      ),
                       Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: TextFormField(
                            //controller: queryController,
                            onChanged: (val){
                            setState(() {
                              this.feedback = val.toString();
                            });
                          },
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,  // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                            expands: true, 
                            
                            style: TextStyle(
                              color: Colors.white, 
                              fontFamily: "Helvetica",
                              
                              ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintMaxLines: 3,
                              hintText: "Please submit your feedback. We will be happy to hear from you😊",
                              hintStyle: TextStyle(
                                fontFamily: "Helvetica", 
                                color: Colors.white,
                                fontSize: 13,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(23),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(23),
                                  borderSide: BorderSide(color: Colors.white),
                                )
                                )
                          )
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                        child: ButtonTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          child: GradientButton(
                            child: Text("Send", style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Poppins",
                            ),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              
                              Color(0xff1C6CAD),
                              Color(0xff20425E),
                            ]
                            ),
                          
                            callback: ()async{
                              if(_formKey.currentState.validate()){
                                if(feedback != null && rating != null){
                                await Firestore.instance.collection("feedback").document(widget.currentUserId).collection("feedbackSubmitted").document(randomNo.toString()).setData({
                                  "username": user.username,
                                  "phoneNumber" : phoneNo == null ? user.phoneNo : phoneNo,
                                  "email ID" : email == null ? user.email : email,
                                  "feedback" : feedback,
                                  "rating" : rating,
                                  "uid" : user.uid,
                                  "userPhotoUrl" : user.photoUrl,
                                  "ticketNumber" : randomNo,
                                  "timestamp" : timestamp,
                                });
                              
                              SnackBar snackbar = SnackBar(content: Text("Feedback Submitted - $randomNo"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.black.withOpacity(0.3),
                                
                              );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
                              Future.delayed(Duration(seconds: 1), (){
                                Navigator.pop(context);
                              });
                              }
                              else if(feedback == null){
                                SnackBar snackbar = SnackBar(content: Text("Please fill your query in the above box"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.black.withOpacity(0.3),
                                );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
                              }
                              else if(rating == null){
                                SnackBar snackbar = SnackBar(content: Text("Please fill your reason in the above box"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.black.withOpacity(0.3),
                                );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
                              }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
       }
     ),
   ); 
  }
}