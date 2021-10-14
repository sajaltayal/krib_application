import 'package:adobe_xd/adobe_xd.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/Authenticate/autentication2_1.dart';
import 'package:fluttershare/Authenticate/authenticati0n2.dart';
import 'package:fluttershare/Welcome/final_welcome_page9.dart';
import 'package:fluttershare/Welcome/welcome_page2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';


class Auth1 extends StatefulWidget {
  
  @override
  _Auth1State createState() => _Auth1State();
}

class _Auth1State extends State<Auth1> {


intro() {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    child: FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: AutoSizeText("Signup", maxLines: 1,style: TextStyle(color: Color(0xff5C5A5A), fontSize: ResponsiveFlutter.of(context).fontSize(8),fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                  onPressed: (){

                  },
                ),

                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                TextButton(
                  child: AutoSizeText("Login", maxLines: 1, style: TextStyle(color: Color(0xff5C5A5A), fontSize: ResponsiveFlutter.of(context).fontSize(5) ,fontFamily: "Poppins", fontWeight: FontWeight.bold),),
                  onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Auth21(signOut: false,))),
                ),
              ],
            ),
          ),

         SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

          FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
              width:  MediaQuery.of(context).size.width * 1,
              
              child: Text(
                'Before you signup please keep your Aadhaar Card (ID) with you.\n\nYour profile name, DOB, \ngender should match with \nthe ID.\n',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveFlutter.of(context).fontSize(3.3),
                  color: const Color(0xff000000),
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          AutoSizeText(
            'By clicking next you agree\nto our terms and conditions',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
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
                  fontSize: 18,
                  color: const Color(0xff0fa83e),
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w600,
                ),
            onOpen: (val){

            },
          )

        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.3, right: MediaQuery.of(context).size.width * 0.05),
          child: FloatingActionButton(
              onPressed: ()async{
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Auth2()));
              },
              child: Icon(Icons.arrow_forward_ios, color: Colors.black,),
              backgroundColor: Color(0xFFFC9F48),
              ),
        ),
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
              child: intro()),

                // Positioned(
                //   top: MediaQuery.of(context).size.height * 0.2,
                //   left: 0,
                //   child: GestureDetector(
                //     onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WelcomePage9())),
                //     child: Container(
                //       color: Colors.transparent,
                //       height: MediaQuery.of(context).size.height * 0.7,
                //       width: MediaQuery.of(context).size.width * 0.45,
                //     ),
                //   ),
                // ),
          
              ],
            ),
        ),
      ),
    );
  }
}
