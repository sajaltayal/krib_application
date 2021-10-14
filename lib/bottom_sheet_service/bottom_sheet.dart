import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/pages_alag/camera_screen.dart';
import 'package:fluttershare/pages_alag/notification_activityFeed.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/pages_alag/search.dart';
import 'package:fluttershare/pages_alag/settings.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';

// class FloatingButton{
  
//   // return Draggable(
//   //   feedback: FloatingActionButton(onPressed: (){},),
//   //   childWhenDragging: Container(),
//   //   child: FloatingActionButton(onPressed: (){},),
//   //   onDragEnd: (details) => print(details.offset),
//   // );
// }
bottomModalSheet(context, Offset offset) {
  return DraggableFloatingActionButton(
    appContext: context,
    mini: false,
    data: "Data",
    offset: offset,
    highlightElevation: 20,
    elevation: 10,
    onPressed: ()async{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      showModalBottomSheet(
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(90)),
        ),
        context: context, 
        isScrollControlled: true,
        builder: (context) {
        return Container(
        height: MediaQuery.of(context).size.height * 0.81,
        decoration: BoxDecoration(
          color: Color(0xff363637),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              offset: Offset(0,-5),
              blurRadius: 20,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
          )
        ),
        
        child: Stack(
          
          children: [
      
            Container(
              height: MediaQuery.of(context).size.height * 0.84,
              width: MediaQuery.of(context).size.width * 0.18,
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
          ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff2D2E55),
                    Color(0xff22526E),
                    Color(0xff1E5F78),
                    Color(0xff17778A),
                    Color(0xff00AAAE),
                  ]
                )
              ),
              child:  RotatedBox(
                quarterTurns: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.05, top: MediaQuery.of(context).size.width * 0.018, right:MediaQuery.of(context).size.height * 0.03,),
                  child: AutoSizeText(
                              'Did you know that Hot water will turn into ice faster than cold water.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ResponsiveFlutter.of(context).fontSize(2),
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.left,
                               maxLines: 2,
                              
            ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.22,
              top: MediaQuery.of(context).size.height * 0.02,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[350],
                highlightColor: Colors.white,
                child: BorderedText(
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                  child: Text(
                    "KRIB",
                    style: TextStyle(
                      fontFamily: "Lovelo-LineLight",
                      fontSize: 35,
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
            ),

            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.clear),
                color: Colors.grey,
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015,),
                iconSize: ResponsiveFlutter.of(context).fontSize(6),
                
                onPressed: () => Navigator.pop(context,),
              ),
            ),

            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: Text("Crafted with 💛 in 🇮🇳", style: TextStyle(
                fontFamily: 'Helvetica_Neue',
                color: Color(0xff707070),
                fontSize: 10
              ),),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              left: MediaQuery.of(context).size.width * 0.22,
              child: AutoSizeText(
              'Menu.',
              style: TextStyle(
                fontFamily: 'Helvetica_Neue',
                fontSize: ResponsiveFlutter.of(context).fontSize(7),
                color: Color(0xfff5f5f5),
                fontWeight: FontWeight.w700,
                height: 0.5970149253731343,
              ),
               maxLines: 1,
              textAlign: TextAlign.left,
            ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.185,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ListTile(
                          onTap: ()async{
                            
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Timeline(currentUserId: user.uid), ctx: context,duration: Duration(milliseconds: 500)));
                          }, 
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
AutoSizeText("Feed", style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Helvetica_Neue"), maxLines: 1,),
                              SizedBox(width: 10,),
                              SvgPicture.asset("assets/Icon/Feed.svg",
                                matchTextDirection: true,
                                height: 35,
                                width: 20,
                              ),
                              // Icon(Icons.home, size: 35, color: Colors.white,),
                            ],
                          ),
                          ),
                        ),
                        ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Search(currentUserId: user.uid), ctx: context,duration: Duration(milliseconds: 500)));
                    
                            }, 
                            title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
AutoSizeText("Search",  maxLines: 1,style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Helvetica_Neue"),),
                            SizedBox(width: 10,),
                            SvgPicture.asset("assets/Icon/Search.svg",
                              matchTextDirection: true,
                              height: 35,
                              width: 20,
                            ),
                            // Icon(Icons.home,  size: 35, color: Colors.white,),
                          
                          ],
                            ),
                        ),
                        ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CameraScreen(isProfileEdit: false, currentUserId: user.uid,), ctx: context,duration: Duration(milliseconds: 500)));

                              //Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: PostUpload(currentUserId: user.uid, isProfileEdit: false,), ctx: context,duration: Duration(milliseconds: 500)));

                            }, 
                            title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
AutoSizeText("Publish",  maxLines: 1,style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Helvetica_Neue")),
                            SizedBox(width: 10,),
                            //Icon(Icons.home,  size: 35, color: Colors.white,),
                            SvgPicture.asset("assets/Icon/Publish.svg",
                              matchTextDirection: true,
                              height: 35,
                              width: 20,
                            ),
                          ],
                            ),
                            ),
                        ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  ActivityFeedNotification(currentUserId: user.uid), ctx: context,duration: Duration(milliseconds: 500)));
                              
                            }, 
                            title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
AutoSizeText("Notification", maxLines: 1, style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Helvetica_Neue")),
                            SizedBox(width: 10,),
                            SvgPicture.asset("assets/Icon/Notification.svg",
                              matchTextDirection: true,
                              height: 35,
                              width: 20,
                            ),
                            //Icon(Icons.home, size: 35, color: Colors.white,),
                          
                          ],
                            ),
                            ),
                        ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  ProfilePage1(profileOfCurrentUserId: user.uid, isProfileOwner: true, isEditing: false), ctx: context,duration: Duration(milliseconds: 500)));

                            }, 
                            title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
AutoSizeText("Profile",  maxLines: 1,style: TextStyle(color: Colors.white,  fontSize: 25, fontFamily: "Helvetica_Neue")),
                            //Icon(Icons.home, size: 35, color: Colors.white,),
                            SizedBox(width: 10,),
                            SvgPicture.asset("assets/Icon/Profile.svg",
                              matchTextDirection: true,
                              height: 35,
                              width: 20,
                            ),
                          ],
                            ),
                            ),
                        ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  Settings(currentUserId: user.uid), ctx: context, duration: Duration(milliseconds: 500)));

                            }, 
                            title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
AutoSizeText("Settings",  maxLines: 1,style: TextStyle(color: Colors.white,  fontSize: 25, fontFamily: "Helvetica_Neue")),
                            SizedBox(width: 10,),
                            SvgPicture.asset("assets/Icon/Settings.svg",
                              matchTextDirection: true,
                              height: 35,
                              width: 20,
                            ),
                            //Icon(Icons.home, size: 35, color: Colors.white,),
                          
                          ],
                            ),
                            ),
                          // TextButton(
                          //   child: AutoSizeText("LogOut", maxLines: 1,style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(2), fontFamily: "Poppins", color: Colors.grey),),
                          //   onPressed: ()async {
                          //   await FirebaseAuth.instance.signOut();
                          //   Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child:  Auth21()));
                          // },
                          // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      );
      } 
      );
                    },
                    child: Icon(Icons.menu_rounded, size: 38,),
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff524d4d),
                    shape: StadiumBorder(
                      side: BorderSide(color: Color(0xff57679f), width: 4)
                    ),
  );
}

bottomHelpSheet(context, String ownerId, String description, String postId) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  showModalBottomSheet(context: context,
   shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.vertical(
       top: Radius.circular(70),
     )
   ),
   backgroundColor: Color(0x422c2c2c),
   builder: (context) {
     if(ownerId != user.uid){
       return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(70),
        ),
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: SizedBox(
             width: MediaQuery.of(context).size.width * 0.9,

            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                              child: Padding(
                    padding: EdgeInsets.only(//left: MediaQuery.of(context).size.width * 0.0, 
                    top: MediaQuery.of(context).size.height * 0.05),
                    child: AutoSizeText(
                          'Any Help?',
                           maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Bitstream Vera Serif',
                            fontSize: ResponsiveFlutter.of(context).fontSize(3.5),
                            color: const Color(0xfffdfdff),
                            letterSpacing: 0.26,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: AutoSizeText(
                    'Report Post',
                     maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Bitstream Vera Serif',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                      color: const Color(0xffef4a58),
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                ),
                  ),
                  onTap: (){

                  },
                ),
                Divider(
                  height: MediaQuery.of(context).size.height * 0.02,
                  indent: MediaQuery.of(context).size.width * 0.08,
                  endIndent: MediaQuery.of(context).size.width * 0.08,
                  color: Colors.grey,
                ),

                ListTile(
                  title: AutoSizeText(
                  'Copy Post Link',
                   maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Bitstream Vera Serif',
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                    color: const Color(0xfffdfdff),
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                  onTap: (){

                  },
                ),
                Divider(
                  height: MediaQuery.of(context).size.height * 0.02,
                  indent: MediaQuery.of(context).size.width * 0.08,
                  endIndent: MediaQuery.of(context).size.width * 0.08,
                  color: Colors.grey,
                ),
                ListTile(
                  title: AutoSizeText(
                  'Cancel',
                   maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Bitstream Vera Serif',
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                    color: const Color(0xfffdfdff),
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
              ],
            ),
          ),
        ), 
          ),
      ),
    );
     }
     
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(70),
          ),
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.05),
                      child: AutoSizeText(
                            'Any Help?',
                             maxLines: 1,
                             
                            style: TextStyle(
                              
                              fontFamily: 'Bitstream Vera Serif',
                              fontSize: ResponsiveFlutter.of(context).fontSize(3.5),
                              color: const Color(0xfffdfdff),
                              letterSpacing: 0.26,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                      child: AutoSizeText(
                      'Edit Post',
                       maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Bitstream Vera Serif',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                        color: const Color(0xffef4a58),
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                  ),
                    ),
                    onTap: ()async {
                      await Navigator.pop(context);
                      topBottom(description, context, postId, user);
                    }
                  ),
                  Divider(
                    height: MediaQuery.of(context).size.height * 0.02,
                    indent: MediaQuery.of(context).size.width * 0.08,
                  endIndent: MediaQuery.of(context).size.width * 0.08,
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: AutoSizeText(
                    'Copy Post Link',
                     maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Bitstream Vera Serif',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                      color: const Color(0xfffdfdff),
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                    onTap: (){

                    },
                  ),
                  Divider(
                    height: MediaQuery.of(context).size.height * 0.02,
                    indent: MediaQuery.of(context).size.width * 0.08,
                    endIndent: MediaQuery.of(context).size.width * 0.08,
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: AutoSizeText(
                    'Cancel',
                     maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Bitstream Vera Serif',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                      color: const Color(0xfffdfdff),
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  
                ],
              ),
            ),
          ), 
            ),
        ),
      );
      });
    }


topBottom(String description, context, String postId, user){
  bool isLoading = false;
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) {
        return StatefulBuilder(
          
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                    color: Colors.transparent,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),),
                    color: Colors.transparent,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05,),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff1f1f1f),
                              ),
                              
                              child: Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                                child: TextFormField(
                                  initialValue: description,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  expands: true,
                                  minLines: null,
                                  maxLines: null,
                                  onChanged: (val){
                                    description = val.toString();
                                  },
                                  style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins", 
                                                fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                                ),
                                  decoration: InputDecoration(
                                    labelText: "Post description...",
                                    labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins", 
                                                fontSize: 20,
                                                ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Color(0xff1f1f1f)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Color(0xff1f1f1f)),
                                    ),
                                  ),

                                ),
                              ),
                            ),
                          ),

                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.8,
                          //   child: TextFormField(
                          //     //controller: _locationController,
                          //     initialValue: user.location == null || user.location == "" ? formatAddress : user.location,
                          //     onChanged: (val){
                          //       this.bio = val.toString();
                          //     },
                          //     decoration: InputDecoration(
                          //         enabledBorder: UnderlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.black),
                          //         ),
                          //         focusedBorder: UnderlineInputBorder(
                                    
                          //           borderSide: BorderSide(color: Colors.black),
                          //         ),
                          //       ),
                          //   ),
                          // ),

                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                            child: ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.9,
                              child: GradientButton(
                                gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff1C6CAD),
                                          Color(0xff20425E),
                                        ]
                                      ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                                child: isLoading ? Shimmer.fromColors(
                                  baseColor: Colors.white,
                                  highlightColor: Color(0xff1f1f1f),
                                  child: Text("Saving...", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                  ),
                                  textAlign: TextAlign.center,),
                                ) : Text("Save", style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                ),
                                callback: ()async{
                                  setState(() {
                                    isLoading = true;
                                  });
                                  !isLoading ? print("changing description") : await postRef.document(user.uid).collection("usersPost").document(postId).updateData({
                                    "description" : description
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),

                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
}
