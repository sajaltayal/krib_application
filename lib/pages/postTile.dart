import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/Authenticate/details3.dart';
import 'package:fluttershare/bottom_sheet_service/custom_image.dart';
import 'file:///Users/sajaltayal/AndroidStudioProjects/krib2/fluttershare/lib/pages/postScreen.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/post.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final String profileOfCurrentUserId;
  final bool timelineRef;
  final bool isEditing;
  PostTile(this.post, this.profileOfCurrentUserId, this.timelineRef,this.isEditing);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile>with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  bool isDeleting = false;
  deletePost(BuildContext parentContext){
    showModalBottomSheet(context: context,
    isDismissible: !isDeleting,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(70),
          )
        ),
      backgroundColor: Color(0x422c2c2c), 
      builder: (context){
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return isDeleting ? Center(
              child: CupertinoTheme( data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CupertinoActivityIndicator(radius: 20,),
              )), ),
            ) : Container(
              height: MediaQuery.of(context).size.height * 0.23,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(70),
                ),
                      child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.21, sigmaY: 12.21),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(//left: MediaQuery.of(context).size.width * 0.05, 
                        top: MediaQuery.of(context).size.height * 0.05),
                        child: AutoSizeText(
                              'Are you sure that you want to \ndelete this publish ?',
                              style: TextStyle(
                                fontSize: ResponsiveFlutter.of(context).fontSize(3.5),
                                color: Color(0xfffdfdff),
                                letterSpacing: 0.26,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                            ),
                      ),
                              
                              
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.5,
                              child: OutlineButton(
                                borderSide: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                child: Text("No",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveFlutter.of(context).fontSize(3.2),
                                  ),
                                ), 
                                onPressed: () => Navigator.pop(context),
                                
                                ),
                            ),
                              SizedBox(width: 10,),
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.5,
                                child: OutlineButton(
                                borderSide: BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                child: Text("Yes", 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveFlutter.of(context).fontSize(3.2),
                                  ),
                                ), 
                                onPressed: ()async{
                                  setState(() {
                                    isDeleting = true;
                                  });
                                  
                                  // delete post from postRef firestore file
                                  await postRef.document(widget.post.ownerId).collection("usersPost").document(widget.post.postId).get().then((doc){
                                    if(doc.exists){
                                      doc.reference.delete();
                                      print("deleted postref");
                                    }
                                  });

                                  // delete all acitivity feed notification
                                  QuerySnapshot snapshot = await activityFeedRef.document(widget.post.ownerId).collection("usersFeed").where("postId", isEqualTo: widget.post.postId).getDocuments();
                                  snapshot.documents.forEach((doc) { 
                                    if(doc.exists){
                                      doc.reference.delete();
                                      print("deleted feedref");
                                    }
                                  });

                                  // delete all comments of that post
                                  QuerySnapshot snapshot1 = await commentRef.document(widget.post.postId).collection("postComments").getDocuments();
                                  snapshot1.documents.forEach((doc) { 
                                    if(doc.exists){
                                      doc.reference.delete();
                                      print("deleted comnentref");
                                    }
                                  });

                                  // delete post from server storage
                                  await storageRef.child("POSTS").child("post_${widget.post.postId}_${widget.profileOfCurrentUserId}.jpg").delete();
                                  print("deleted storgeref");
            
                                  setState(() {
                                    isDeleting = false;
                                  });
                                  Navigator.pop(context);
                                  
                                },
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      ],
                      ),
                ),

              ),
            ),
      );
          }
        );
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        widget.isEditing ? deletePost(context) : Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: PostScreen(postUrl: widget.post.postUrl, ownerId: widget.post.ownerId,postId: widget.post.postId,profileOfCurrentUserId: widget.profileOfCurrentUserId, timelineRef: widget.timelineRef,),ctx: context, duration: Duration(milliseconds: 20)));
      } ,
      child: cachedNetworkImage(widget.post.postUrl, widget.isEditing),
    );
  }
}

class PostTile1 extends StatefulWidget {
  final Post post;
  final String profileOfCurrentUserId;
  final bool timelineRef;
  PostTile1(this.post, this.profileOfCurrentUserId, this.timelineRef);

  @override
  _PostTile1State createState() => _PostTile1State();
}

class _PostTile1State extends State<PostTile1>with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: PostScreen(postUrl: widget.post.postUrl, ownerId: widget.post.ownerId,postId: widget.post.postId,profileOfCurrentUserId: widget.profileOfCurrentUserId, timelineRef: widget.timelineRef,),ctx: context, duration: Duration(milliseconds: 20)));
      } ,
      child: cachedNetworkImage1(widget.post.postUrl),
    );
  }
}