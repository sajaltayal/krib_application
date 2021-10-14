
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttershare/Authenticate/authentication1.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';


class WelcomePage9 extends StatefulWidget {
  @override
  _WelcomePage9State createState() => _WelcomePage9State();
}

class _WelcomePage9State extends State<WelcomePage9> {
  @override
  void initState() { 
    super.initState();
    navigate();
  }

  bool isSelected = false;

  navigate(){
    
    Future.delayed(Duration(milliseconds: 700), (){
      setState(() {
      isSelected = true;
    });
      Future.delayed(Duration(milliseconds: 700), (){
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Auth1()));
      });
    });
  }

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
                      width:  MediaQuery.of(context).size.width * 0.9,
                      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 550),
                 style: isSelected ? TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: ResponsiveFlutter.of(context).fontSize(0),
                        color: const Color(0xff000000),
                        letterSpacing: 0.59,
                        fontWeight: FontWeight.w600,
                  ): TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: ResponsiveFlutter.of(context).fontSize(7),
                        color: const Color(0xff000000),
                        letterSpacing: 0.59,
                        fontWeight: FontWeight.w600,
                  ),
                child: Text(
                  'All Ready!',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
                    ),
                  )
                  
                )
          ],
        ),
        ),
            ],
          ),
      ),
    );
  }
}
