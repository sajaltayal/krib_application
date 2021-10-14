
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttershare/Authenticate/details.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:responsive_flutter/responsive_flutter.dart';



class Auth3 extends StatefulWidget {
  
  @override
  _Auth3State createState() => _Auth3State();
}

class _Auth3State extends State<Auth3> {
  TextEditingController _controller = new TextEditingController();
  bool isUsernameValid = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deleteUsername();
  }

  deleteUsername()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    usersRef.document(user.uid).get().then((doc){
      if(doc.exists){
        if(doc['username'] != null){
          doc.reference.delete();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Future<bool> checkUsername(String username)async{
    final result = await usersRef
        .where('username', isEqualTo: username)
        .getDocuments();
    setState(() {
      return result.documents.isEmpty ? isUsernameValid = true : isUsernameValid = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        
        backgroundColor: Color(0xff363637),
        resizeToAvoidBottomInset: true,
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
                            style: TextStyle(
                              fontFamily: 'Lovelo-LineLight',
                              fontSize: 18,
                              color: const Color(0xffffffff),
                              letterSpacing: -0.36,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            'Somewhere on Internet',
                            style: TextStyle(
                              fontFamily: 'SFProText-Semibold',
                              fontSize: 10,
                              color: const Color(0xffffffff),
                              letterSpacing: -0.2,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
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

          Positioned(
            left: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: AutoSizeText(
          'Let’s make your\nunique username',
          maxLines: 2,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveFlutter.of(context).fontSize(4),
            color: const Color(0xff5c5a5a),
            letterSpacing: 0.35000000000000003,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
      ),
  ),

  Positioned(
      left: MediaQuery.of(context).size.width * 0.1,
      top: MediaQuery.of(context).size.height * 0.3,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Form(
          key: _formKey,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    validator: (val){
                      if(val.isEmpty){
                        return ("Please enter a Username");
                      }
                    },
                  controller: _controller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFC9F48))
                    ),
                        hintText: "username",

                        errorText: isUsernameValid ? null : "This username already exist. Try something else",
                        hintStyle: TextStyle(
                            color: Color(0xffbcb8b8),
                            fontSize: 20,
                        ),
                      ),
            ),
              ),
      ),
  ),

  Positioned(
          top: MediaQuery.of(context).size.height * 0.45,
          right: MediaQuery.of(context).size.width * 0.1,
          child: FloatingActionButton(
            onPressed: ()async{
              setState(() {
                  isLoading = true;
              });
              await checkUsername(_controller.text.trim());
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                  isLoading = false;
              });
              if(_formKey.currentState.validate()){
               if(isUsernameValid){
                     Navigator.push(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => Details(), transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child,),transitionDuration: Duration(milliseconds: 300), settings: RouteSettings(arguments: ScreenArguments(username: _controller.text))));
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
              ],
            ),
                ),
        ),
      ),
    );
  }
}
