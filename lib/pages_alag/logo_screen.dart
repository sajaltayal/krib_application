import 'dart:async';

import 'package:blinking_text/blinking_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/constants.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class Logo extends StatefulWidget {

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<Logo>{

  @override
  void initState() { 
    super.initState();
    Timer(Duration(seconds: 2), (){
      Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      body: Center(
        child: BlinkText(
          "KRIB",
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(18), 
            fontFamily: "Lovelo-LineLight", 
            color: Colors.grey[100],
             letterSpacing: 2,
            shadows: [
        Shadow(
          color: Colors.white,
          offset: Offset(0, 0),
          blurRadius: 50,
        ),
                ],
),
            times: 5,
            duration: Duration(
              milliseconds: 90,
            ),
            ),
      ),
    );
  }
}

