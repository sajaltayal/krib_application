import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/Welcome/final_welcome_page9.dart';
import 'package:fluttershare/Welcome/welcome_page2.dart';
import 'package:fluttershare/Welcome/welcome_page7.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class WelcomePage8 extends StatelessWidget {
  
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
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: 0),
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(5.5),
                                  color: Color(0xff5c5a5a),
                                  height: 1.2,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Still got some\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'doubts',
                                    style: TextStyle(
                                      color: const Color(0xff67a272),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '🤨',
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' \ncheck out the \n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'website',
                                    style: TextStyle(
                                      color: const Color(0xff253ad8),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' to learn\nmore.\n ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),

          FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
              child: Linkify(
                    text: 
                'www.krib.me/got_some_doubts',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 23.5,
                    color: const Color(0xff190fa8),
                ),
                onOpen: (link) async{
                    if(await canLaunch(link.url)){
                            await launch(link.url);
                    }else{
                            throw 'Could not launch ${link.url}';
                    }
                },
              ),
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
        
       
        Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WelcomePage9())),
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
                  onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WelcomePage7())),
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
