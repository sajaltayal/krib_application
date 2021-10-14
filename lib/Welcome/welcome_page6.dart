import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/Welcome/welcome_page2.dart';
import 'package:fluttershare/Welcome/welcome_page5.dart';
import 'package:fluttershare/Welcome/welcome_page7.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';


class WelcomePage6 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Color(0xff1f1f1f));
    return Scaffold(
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
                  
                )
          ],
        ),
        ),
        
        
        Positioned(
          left: MediaQuery.of(context).size.width * 0.18,
          top: MediaQuery.of(context).size.height * 0.33,
          right: MediaQuery.of(context).size.width * 0.18,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: ResponsiveFlutter.of(context).fontSize(5.5),
                  color: const Color(0xff5c5a5a),
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'Next card is \n',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'Important',
                    style: TextStyle(
                      color: const Color(0xffe33846),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '.\nDo not blink\n👀.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.left,
            ),
          )
        ),
        
        Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WelcomePage7())),
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                left: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WelcomePage5())),
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                ),
              ),   

        
        
            ],
          ),
      ),
    );
  }
}
