import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershare/Welcome/welcome_page1.dart';
import 'constants.dart';
import 'package:fluttershare/pages_alag/logo_screen.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: Color(0xff1f1f1f),
    ));
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_){
    print("Timestamp enabled in snapshots\n");
  }, onError: (_){
    print("Error enabling timestamp in snapshot\n");
  });
  runApp(MyApp());
}

class Pallette{
  static const MaterialColor primarySwatch = const MaterialColor(
    0xffffffff,
    const <int, Color>
    {
    50:Color(0xffffffff),
    100:Color(0xffffffff),
    200:Color(0xffffffff),
    300:Color(0xffffffff),
    400:Color(0xffffffff),
    500:Color(0xffffffff),
    600:Color(0xffffffff),
    700:Color(0xffffffff),
    800:Color(0xffffffff),
    900:Color(0xffffffff),
    }
      );
    }

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData && (!snapshot.data.isAnonymous)){
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Pallette.primarySwatch,
              primaryColor: Color(0xff1f1f1f),
            ),
            home: Logo(),
            routes: <String, WidgetBuilder>{
              SPLASH_SCREEN: (BuildContext context) => Logo(),
              HOME_SCREEN: (BuildContext context) => Timeline(currentUserId: snapshot.data.uid,),
            },
            //home: Timeline(currentUserId: snapshot.data.uid,),
          );
        }
        return MaterialApp(
          theme: ThemeData(
            cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)
          ),
          home: Logo(),
          routes: <String, WidgetBuilder>{
              SPLASH_SCREEN: (BuildContext context) => Logo(),
              HOME_SCREEN: (BuildContext context) => WelcomePage1(),
            },
          //home: WelcomePage1(),
        );
        
      },
    );
  }
}
