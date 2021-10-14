import 'package:adobe_xd/adobe_xd.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:fluttershare/Authenticate/autentication2_1.dart';
import 'package:fluttershare/Authenticate/phoe_otp_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'details3.dart';
import 'package:fluttershare/service_and_classes/user.dart';

class Auth2 extends StatefulWidget {
  
  @override
  _Auth2State createState() => _Auth2State();
}

class _Auth2State extends State<Auth2> {
   final _formKey = GlobalKey<FormState>();
   TextEditingController _controller = new TextEditingController();
   TextEditingController _emailController = new TextEditingController();
   bool isMobileValid = true;
   bool isLoading = false;
   
    @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
 // main screen
  Container intro() {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    child: FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: AutoSizeText("Signup", style: TextStyle(color: Color(0xff5C5A5A), fontSize: ResponsiveFlutter.of(context).fontSize(8),fontFamily: "Poppins", fontWeight: FontWeight.bold),maxLines: 1,),
                  onPressed: (){
                  },
                ),

                SizedBox(width: MediaQuery.of(context).size.width * 0.1),

                TextButton(
                  child: AutoSizeText("Login", style: TextStyle(color: Color(0xff5C5A5A),fontSize: ResponsiveFlutter.of(context).fontSize(5),fontFamily: "Poppins", fontWeight: FontWeight.bold),maxLines: 1,),
                  onPressed: (){
                   Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Auth21(signOut: false,)));
                  
                  },
                ),
              ],
            ),
          ),

         SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            child: TextFormField(
              validator: (val){
                if(val.isEmpty){
                  return ("Please enter your Mobile Number");
                }
                
              },
              decoration: InputDecoration(
                // country code
                // prefix: Padding(
                //   padding: EdgeInsets.all(4),
                //   child: Text("+1"),
                // ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFC9F48))
                ),
                labelText: "Mobile Number",
                labelStyle: TextStyle(
                  fontSize: 26
                ),
                errorText: isMobileValid ? null : _controller.text.length < 10 ? "Please enter a 10 digit number" : "This number is already registered to an account",
                // labelStyle: TextStyle(
                //   color: Color(0xffbcb8b8),
                //   fontSize: ResponsiveFlutter.of(context).fontSize(3),
                //   fontFamily: "Poppins",
                //   fontWeight: FontWeight.w600
                // ),
              ),
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
                    ),
                    SizedBox(height: 15),
            SizedBox(
                    width: MediaQuery.of(context).size.width * 1,

            child: TextFormField(
              validator: (val){
                if(val.isEmpty){
                  return ("Please enter your Email ID");
                }
              },
              controller: _emailController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFC9F48))
                ),
                labelText: "Email ID",
                labelStyle: TextStyle(
                  fontSize: 26
                ),
                errorText: isEmailValid ? null : "Please check your Email ID",
                // labelStyle: TextStyle(
                //   color: Color(0xffbcb8b8),
                //   fontSize: ResponsiveFlutter.of(context).fontSize(3),
                //   fontFamily: "Poppins",
                //   fontWeight: FontWeight.w600
                // ),
              ),
            ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    ),
  );
  }
 
 Future<bool> checkNumber(String phoneNo)async{
   if(phoneNo.length < 10){
     setState(() {
       return isMobileValid = false;
     });
   }
   else if (phoneNo.length == 10){
 final result = await usersRef
        .where('phoneNo', isEqualTo: phoneNo)
        .getDocuments();
    setState(() {
      return result.documents.isEmpty ? isMobileValid = true : isMobileValid=false;
    });
   }
  }

  Future<bool> checkEmail(String email)async{
    if(email.isEmpty){
      return isEmailValid = false;
    }
    if(email.contains("@", 1) && email.contains(".") && email.contains(RegExp(r'[a-z]'), 0) && !(email.contains(RegExp(r'[A-Z]'), 0))){
      setState(() {
        return isEmailValid = true;
      });
    }
    else {
      setState(() {
        return isEmailValid = false;
      });
    }
  }
  bool isEmailValid = true;
  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return Scaffold(
      
      backgroundColor: Color(0xff363637),
      resizeToAvoidBottomInset: false,
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.4, right: MediaQuery.of(context).size.width * 0.07),
        child: FloatingActionButton(
                onPressed: ()async{
                  setState(() {
                    isLoading = true;
                  });
                  await checkNumber(_controller.text.trim());
                  await checkEmail(_emailController.text.trim());
                  setState(() {
                        isLoading = false;
                      });
                  if(_formKey.currentState.validate()){
                    if(isMobileValid && isEmailValid){
                      Navigator.push(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => PhoneOtpPage(_controller.text), transitionsBuilder: (c, anim , a2, child) => FadeTransition(child: child, opacity: anim,), transitionDuration: Duration(milliseconds: 300), settings: RouteSettings(arguments: ScreenArguments(email: _emailController.text, phoneNo: _controller.text,))));
                    }
                  }
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
    );
  }
}

