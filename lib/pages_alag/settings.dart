import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttershare/Authenticate/autentication2_1.dart';
import 'package:fluttershare/bottom_sheet_service/bottom_sheet.dart';
import 'package:fluttershare/pages_alag/manage_notifications.dart';
import 'package:fluttershare/settings_pages/manage_account.dart';
import 'package:fluttershare/settings_pages/Feedback.dart';
import 'package:fluttershare/settings_pages/support.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class Settings extends StatefulWidget {
  final String currentUserId;

  Settings({this.currentUserId});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List items = ["Invite Friends", "Support", "Manage account","Notifications", "Privacy", "Feedback", "Terms and Conditions", "About", "Tutorial", "LogOut", "logo"];
  bool isLoggingOut = false;
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xff232526));
    return Scaffold(
      
      //backgroundColor: Color(0xff363637),
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
                      ]
                    )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    FittedBox(
                fit: BoxFit.fitWidth,
                child: AutoSizeText.rich( 
                  TextSpan(
                      style: TextStyle(
                      fontSize: 72,
                      fontFamily: 'Helvetica Neue',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                  ),
                  children: [
                      TextSpan(text: "Settings", style: TextStyle(letterSpacing: 1.5)),
                      TextSpan(text: ".", style: TextStyle(color: Colors.lime[900])),
                  ]
                  ),
                ),
              ),
                  Expanded(
                    child: ListView.builder(
                        //physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index){
                            return items[index] != "logo" ? Padding(
                              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2, top: items[index] == "Invite Friends" ? MediaQuery.of(context).size.height * 0.035 : 0),
                              child: Container(
                                decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(4, 4),
                                    blurRadius: 5,
                                    spreadRadius: -5,
                                    
                                          ),
                                ],
                                borderRadius: BorderRadius.circular(20)
                              ),
                                child: Card(
                                  color: Color(0xff363637),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  shadowColor: Colors.black,
                                  
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: ListTile(
                                      onTap: ()async{
                                        if(items[index] == "LogOut"){
                                          return showDialog(
                                            context: context,
                                            builder: (context){
                                              return StatefulBuilder(
                                                builder: (context, StateSetter setState) => 
                                                SimpleDialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                            backgroundColor: Color(0xff363637),
                                            children: isLoggingOut ? [
                                                SimpleDialogOption(
                                                  child:  CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 30),
                                                    child: CupertinoActivityIndicator(radius: 20,),
                                                  )
                                                  ), 
                                                  ) ,
                                                )
                                                ] : [
                                                SimpleDialogOption(
                                                  child: Text("Do you want to Logout?",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Helvetica"
                                                  ),
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        child: Text("Cancel",
                                                        style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Helvetica"
                                                  ),
                                                        ),
                                                        onPressed: () => Navigator.pop(context),
                                                      ),

                                                      TextButton(
                                                        child: Text("Logout",
                                                        style: TextStyle(
                                                    color: Colors.red,
                                                    fontFamily: "Poppins"
                                                  ),
                                                        ),
                                                        onPressed: () async{
                                                          setState(() {
                                                            isLoggingOut = true;
                                                          });
                                                          try{
                                                            await FirebaseAuth.instance.signOut();
                                                            Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: Auth21(signOut: true,), ctx: context));
                                                            setState(() {
                                                              isLoggingOut = false;
                                                            });
                                                          }catch(e){
                                                            print('${e.message}');
                                                          }
                                                        }
                                                      ),
                                                    ],
                                                  )
                                                ),
                                            ],
                                          ),
                                              );
                                            }
                                          );
                                          
                                        }
                                        if(items[index] == "Manage account"){
                                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: ManageAccount(currentUserId: widget.currentUserId,)));
                                        }
                                        if(items[index] == "Notifications"){
                                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: ManageNotification(currentUserId: widget.currentUserId,)));
                                        }
                                        if(items[index] == "Support"){
                                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: Support(currentUserId: widget.currentUserId,)));
                                        }
                                        if(items[index] == "Feedback"){
                                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: FeedBack(currentUserId: widget.currentUserId,)));
                                        }
                                      },
                                      tileColor: Color(0xff363637),
                                      //tileColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                      title: AutoSizeText(items[index],maxLines: 1, style: TextStyle(color: items[index] == "LogOut" ? Colors.red : Colors.white, fontSize: 23, fontFamily: 'Helvetica Neue',fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                ),
                              ),
                            ) :  Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.04, left: MediaQuery.of(context).size.width * 0.02,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                        baseColor: Colors.grey[350],
                        highlightColor: Colors.white,
                        child: BorderedText(
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                          child: Text(
                            "KRIB",
                            style: TextStyle(
                              fontFamily: "Lovelo-LineLight",
                              fontSize: 40,
                              //ResponsiveFlutter.of(context).fontSize(4),
                              letterSpacing: 2,
                              shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: Offset(0, 0),
                            blurRadius: 20,
                          ),
                        ],
                            ),
                          ),
                        ),
                      ),
                                
                      
                      Text("Crafted with 💛 in 🇮🇳", style: TextStyle(
                        fontFamily: 'Helvetica_Neue',
                        color: Color(0xff707070),
                        fontSize: 10
                      ),),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      )
                              ],
                            ),
                          ),
                        );
                          }
                          ),
                  ),
                ],
              ),
            ),
            bottomModalSheet(context, Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.8),)
          ],
        ),
      ),
    );
  }
}