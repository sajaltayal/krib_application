import 'package:adobe_xd/adobe_xd.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/Authenticate/details2.dart';
import 'package:fluttershare/Welcome/welcome_page2.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';


class Details extends StatefulWidget {

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  final usersRef = Firestore.instance.collection("users");
  String fullName;
  List<String> queries = ["Male", "Female", "Other"];
  String gender;
  bool isLoading = false;
  String dob;

  @override
  void initState() { 
    super.initState();
    updateUserInFirestore();
  }

  updateUserInFirestore()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentSnapshot doc = await usersRef.document(user.uid).get();

  if(doc.exists)  {
    // navigate further details library
    // modal route for multiple arguments
    final ScreenArguments arg = ModalRoute.of(context).settings.arguments;
    
    // set initial data gathered from signup process to newly created user

    usersRef.document(user.uid).updateData({
      "username" : arg.username
    });
  }
  }

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
              child: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Container(
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
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                        AutoSizeText(
                          'KRIB',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Lovelo-LineLight',
                            fontSize: 18,
                            color: const Color(0xffffffff),
                            letterSpacing: -0.36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AutoSizeText(
                          'Somewhere on Internet',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'SFProText-Semibold',
                            fontSize: 10,
                            color: const Color(0xffffffff),
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.015, 0,0),
                      height: MediaQuery.of(context).size.height * 0.87,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(39),
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                color: const Color(0xff000000),
                offset: Offset(0, 15),
                blurRadius: 20,
                                ),
                        ],
                        
                      ),
                      
                    )
            ],
          ),
        ),
        ),
              ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.height * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: AutoSizeText.rich(
    TextSpan(
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: const Color(0xff5c5a5a),
            letterSpacing: 0.24,
        ),
        children: [
            TextSpan(
              text: 'Following details should\n',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'match',
              style: TextStyle(
                color: const Color(0xffe33846),
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' with your ID and \ncannot be ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'changed',
              style: TextStyle(
                color: const Color(0xffe33846),
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' later.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
    ),
    
    textAlign: TextAlign.left,
  ),
          ),
        ),

        Positioned(
          right: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.height * 0.28,
          left: MediaQuery.of(context).size.width * 0.1,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    //focusNode: FocusNode(canRequestFocus: false),
                    validator: (val){
              if(val.isEmpty){
                return ("Please enter your Name");
              }
            },
                    onChanged: (val){
                    
                        this.fullName = val;
                      
                    },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFC9F48))
              ),
              hintText: "Full Name",
              hintStyle: TextStyle(
                  color: Color(0xffbcb8b8),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
              ),
            ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,),
                    child: DropdownButtonFormField(
                          //value: "App Crash",
                          dropdownColor: Colors.white,
                          items: queries.map((query){
                            return DropdownMenuItem(
                              value: query,
                              child: Text("$query"),
                            );
                          }).toList(),
                          //controller: reasonController,
                          onChanged: (val){
                            setState(() {
                              this.gender = val.toString();
                            });
                          },
                          
                          
                          
                          decoration: InputDecoration(
                            hintText: "Gender",
                            hintStyle: TextStyle(
                              fontSize: 20,
                    fontWeight: FontWeight.w600, 
                              color: Color(0xffbcb8b8),
                              
                              ),
                            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFC9F48))),
                            
                          ),
                          
                        ),
                  ),
            //       child: Container(
            //         margin : EdgeInsets.only(top: 20),
            //         child: TextFormField(
            //           validator: (val){
            //   if(val.isEmpty){
            //     return ("Please enter your Gender");
            //   }
            // },
            //           onChanged: (val){
                        
            //               this.gender = val;
                    
            //           },
            // decoration: InputDecoration(
            //   focusedBorder: OutlineInputBorder(
            //     borderSide: BorderSide(color: Color(0xFFFC9F48))
            //   ),
            //   hintText: "Gender",
            //   hintStyle: TextStyle(
            //         color: Color(0xffbcb8b8),
            //         fontSize: ResponsiveFlutter.of(context).fontSize(2.4),
            //         fontFamily: "Poppins",
            //         fontWeight: FontWeight.w600
            //   ),
            // ),
            //         ),
            //       ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      onTap: ()async{
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = await showDatePicker(
                          context: context, 
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget child){
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                    primary: Color(0xff1f1f1f),
                                    onPrimary: Colors.white,
                                    surface: Colors.blue,
                                    onSurface: Color(0xff1f1f1f),
                                    ),
                                dialogBackgroundColor:Colors.white,
                              ),
                              child: child,
                            );
                          }
                          );
                          this.dob = date.toIso8601String();
                        },
                        validator: (val){
                          if(dob.isEmpty){
                            return ("Please enter your Date Of Birth (DOB)");
                          }
                        },
            //           onChanged: (val){
                      
            //               this.dob = dob;
                    
            //           },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFC9F48))
              ),
              hintText: dob == null ? "DOB(DD/MM/YYYY)" : dob,
              hintStyle: TextStyle(
                    color: Color(0xffbcb8b8),
                    fontSize: 20,
                    fontWeight: FontWeight.w600
              ),
            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
        top: MediaQuery.of(context).size.height * 0.57,
        right: MediaQuery.of(context).size.width * 0.1,
        child: FloatingActionButton(
          heroTag: "btn1",
          onPressed: ()async{
            setState(() {
              isLoading = true;
            });
            if(_formKey.currentState.validate()){
              setState(() {
                isLoading = false;
              });
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.push(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => Details2(), transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child,),transitionDuration: Duration(milliseconds: 300), settings: RouteSettings(arguments: ScreenArguments(dob: dob, fullName: fullName, gender: gender))));
              
            }
            
            // save the details assigned to a currentUser uid; then,
            
//          
          },
          child: isLoading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) : Icon(Icons.arrow_forward_ios, color: Colors.black,),
          backgroundColor: Color(0xFFFC9F48),
          ),
    ),

    Positioned(
        top: MediaQuery.of(context).size.height * 0.57,
        left: MediaQuery.of(context).size.width * 0.1,
        child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: ()async{
            setState(() {
              isLoading = true;
            });
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            usersRef.document(user.uid).updateData({
              "username" : FieldValue.delete(),
            });
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context, PageTransition(child: null, type: PageTransitionType.fade));
          },
          child: isLoading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) : Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
          backgroundColor: Color(0xFFFC9F48),
          ),
    ),

    Positioned(
        top: MediaQuery.of(context).size.height * 0.7,
        left:MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: AutoSizeText.rich(
          
    TextSpan(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveFlutter.of(context).fontSize(2.9),
          color: const Color(0xff5c5a5a),
          letterSpacing: 0.24,
        ),
        children: [
          TextSpan(
            text: 'These details will be used\nto ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'verify',
            style: TextStyle(
              color: const Color(0xffe33846),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' your profile. We\nwill never share these \n',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'details',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          TextSpan(
            text: ' with anybody.',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
    ),
    
    textAlign: TextAlign.left,
  )
    ),
            ],
          ),
      ),
    );
  }
}
