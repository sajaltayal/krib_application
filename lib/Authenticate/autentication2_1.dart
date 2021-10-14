import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttershare/Authenticate/authentication1.dart';
import 'package:fluttershare/Authenticate/phoe_otp_page.dart';
import 'package:fluttershare/Authenticate/phone_otp.dart';
import 'package:fluttershare/pages/profile_page.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

final _auth = FirebaseAuth.instance;
class Auth21 extends StatefulWidget {
  final bool signOut;

  Auth21({this.signOut});
  @override
  _Auth21State createState() => _Auth21State();
}

class _Auth21State extends State<Auth21> {

    final _key = GlobalKey<FormState>();
    final TextEditingController _textController = new TextEditingController();
    bool isMobileValid = true;
    bool isLoading = false;
    @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    
    super.dispose();
  }

  Future<bool> checkNumber(String phoneNo)async{
    final result = await usersRef
        .where('phoneNo', isEqualTo: phoneNo)
        .getDocuments();
    setState(() {
      return result.documents.isEmpty ? isMobileValid = false : isMobileValid = true;
    });
  }

 // main screen
  Container intro() {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: AutoSizeText("Signup", style: TextStyle(color: Color(0xff5C5A5A), fontSize: ResponsiveFlutter.of(context).fontSize(5),fontFamily: "Poppins", fontWeight: FontWeight.bold),maxLines: 1,),
                onPressed: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Auth1()));
                },
              ),

              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              TextButton(
                child: AutoSizeText("Login", style: TextStyle(color: Color(0xff5C5A5A), fontSize: ResponsiveFlutter.of(context).fontSize(8),fontFamily: "Poppins", fontWeight: FontWeight.bold),maxLines: 1,),
                onPressed: (){

                
                },
              ),
            ],
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          
          keyboardType: TextInputType.number,
          controller: _textController,
          maxLength: 10,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFC9F48))
            ),
            labelText: "Mobile Number",
            labelStyle: TextStyle(
              fontSize: 20
            ),
            errorText: isMobileValid ? null : "No account exist with this number",
            // labelStyle: TextStyle(
            //       color: Color(0xffbcb8b8),
                  
            //       fontFamily: "Poppins",
            //       fontWeight: FontWeight.w600
            //     ),
          ),
          validator: (val){
            if(val.isEmpty){
              return ("Please enter your Mobile Number");
            }
            else{
              return null;
            }
          },
        ),
                ),
                
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.41,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
              'By clicking next you agree\nto our terms and conditions',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: const Color(0xff1A0303),
                letterSpacing: 0.2,
                fontWeight: FontWeight.w300,
                
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),

            Linkify(
              text: "Terms and Conditions",
              style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: const Color(0xff0fa83e),
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w600,
                  ),
            )
              ],
            ),
          )

      ],
    ),
  );
  }
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return WillPopScope(
      onWillPop: ()async{
        if(widget.signOut){
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        else if(!widget.signOut){
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xff363637),
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Stack(
              children: [
            Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                        Text(
                          'KRIB',
                          style: TextStyle(
                            fontFamily: 'Lovelo-LineLight',
                            fontSize: 18,
                            color: const Color(0xffffffff),
                            letterSpacing: -0.36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Somewhere on Internet',
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
                      
                    ),

                    
              ],
            ),
            ),
            Positioned(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      child: intro(),
                      )
                ],
              ),
          ),
        ),
         floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.45, right: MediaQuery.of(context).size.width * 0.07),
          child: FloatingActionButton(
                onPressed: ()async{
                  setState(() {
                    isLoading = true;
                  });
                  await checkNumber(_textController.text);
                  setState(() {
                        isLoading = false;
                      });
                  if(_key.currentState.validate()){
                    if(isMobileValid){
                      
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PhoneOtpPage1(_textController.text)));
                    }
                    // call mobile phone auth verification
                  }
                  
                },
                child: isLoading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) : Icon(Icons.arrow_forward_ios, color: Colors.black),
                backgroundColor: Color(0xFFFC9F48),
              ),
        ),
      ),
    );
  }
}