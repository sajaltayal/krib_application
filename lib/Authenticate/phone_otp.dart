
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttershare/pages/profile_page.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

final _auth = FirebaseAuth.instance;
final DateTime timestamp = DateTime.now();

class PhoneOtpPage1 extends StatefulWidget {
  final String phoneNo;
  PhoneOtpPage1(this.phoneNo);
  
  @override
  _PhoneOtpPage1State createState() => _PhoneOtpPage1State();
}

class _PhoneOtpPage1State extends State<PhoneOtpPage1> {
  String _verificationCode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  @override
void initState(){ 
  super.initState();
  _verifyPhone();  
}

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff363637),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.height * 0.52),
                              child: Text.rich(
                               TextSpan(
                                 children: [
                                   TextSpan(
          text: 'Verify number:     \n',
          style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveFlutter.of(context).fontSize(3.5),
                color: const Color(0xff5c5a5a),
                letterSpacing: 0.35000000000000003,
                fontWeight: FontWeight.w600,
          ),
    ),

    TextSpan(text: "+91 ${widget.phoneNo}",
    style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: ResponsiveFlutter.of(context).fontSize(3.5),
                color: const Color(0xff5c5a5a),
                letterSpacing: 0.35000000000000003,
                fontWeight: FontWeight.w600,
          ),
    ),
                                 ]
                               )
                              
                              ),
                            ),
                          ],
                        ),
              ),
            ),
                    
                  )
            ],
          ),
        ),
        ),

    Positioned(
        top: MediaQuery.of(context).size.height * 0.36,
        left: MediaQuery.of(context).size.width * 0.1,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.84,
          child: PinEntryTextField(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            fields: 6,
            showFieldAsBox: false,
            onSubmit: (String pin)async{
              setState(() {
                isLoading = true;
              });
              try{
                await _auth.signInWithCredential(
                PhoneAuthProvider.getCredential(verificationId: _verificationCode, smsCode: pin)).
                then((user){
                  if(user != null){
                    
                    setState(() {
                      isLoading = false;
                    });
                    //navigator to next page
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Timeline(currentUserId: user?.uid)));
                    print(user.uid);
                  }
                });
              }catch (e) {
                setState(() {
                  isLoading = false;
                });
                FocusScope.of(context).unfocus();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Invalid OTP"),));
              }
            },
          ),
        ),
    ),











// some gadbad h is button ke onPressed mein
    Positioned(
        top: MediaQuery.of(context).size.height * 0.5,
        right: MediaQuery.of(context).size.width * 0.1,
        child: FloatingActionButton(
          heroTag: "btn1",
          onPressed: ()async{
            setState(() {
              isLoading = true;
            });
            await _verifyPhone();
            //Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
            
          },
          child: isLoading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) :  Icon(Icons.arrow_forward_ios, color: Colors.black,),
          backgroundColor: Color(0xFFFC9F48),
          ),
    ),
    Positioned(
        top: MediaQuery.of(context).size.height * 0.5,
        left: MediaQuery.of(context).size.width * 0.1,
        child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: (){
            Navigator.pop(context, PageTransition(type: PageTransitionType.fade, child: null));
//          _verifyPhone(); permanent code
          },
          child: isLoading ? Center(child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CupertinoActivityIndicator(radius: 20,),
            )
            ), 
            ) ,) : Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
          backgroundColor: Color(0xFFFC9F48),
          ),
    )
            ],
          ),
      ),
    );
  }
_verifyPhone()async{
  await _auth.verifyPhoneNumber(
    phoneNumber: "+91${widget.phoneNo}", 
    verificationCompleted: (FirebaseUser user)async{
      if(user != null){
        setState(() {
          isLoading = false;
        });
       Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Timeline(currentUserId: user?.uid)));
        
      }
    }, 
    verificationFailed: (AuthException e){
      print(e.message);
    }, 
    codeSent: (String verificationID, [int resendToken]){
      setState(() {
        _verificationCode = verificationID;
      });
    }, 
    codeAutoRetrievalTimeout: (String verificationID){
      setState(() {
        _verificationCode = verificationID;
      });
    },
    timeout: Duration(seconds: 10),
    );
}

}






