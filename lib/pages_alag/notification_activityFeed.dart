

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/bottom_sheet_service/bottom_sheet.dart';
import 'file:///Users/sajaltayal/AndroidStudioProjects/krib2/fluttershare/lib/pages/postScreen.dart';
import 'package:fluttershare/pages_alag/manage_notifications.dart';
import 'package:fluttershare/pages_alag/profile_page1.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedNotification extends StatefulWidget {
  final String currentUserId;

  ActivityFeedNotification({this.currentUserId});
  @override
  _ActivityFeedNotificationState createState() => _ActivityFeedNotificationState();
}

class _ActivityFeedNotificationState extends State<ActivityFeedNotification> with AutomaticKeepAliveClientMixin<ActivityFeedNotification>{
  int count;

  getActivityFeed()async{
    QuerySnapshot snapshot = await activityFeedRef.document(widget.currentUserId).collection("usersFeed").orderBy("timestamp", descending: true).limit(50).getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) { 
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });
    setState(() {
      count = feedItems.length;
    });
    return feedItems;
  }
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {

    super.build(context);
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
                      ]
                    )
              ),
              child: FutureBuilder(
                future: getActivityFeed(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
            fit: BoxFit.fitWidth,
            child: AutoSizeText.rich(
        TextSpan(
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: ResponsiveFlutter.of(context).fontSize(8),
            ),
            children: [
              TextSpan(
                text: 'Notification',
                
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xfff5f5f5),
                ),
              ),
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: const Color(0xff00b98e),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
        ),
        
        textAlign: TextAlign.left,
    ),
          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[500].withOpacity(0.1),
                            highlightColor: Colors.grey[500].withOpacity(0.3),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                                itemCount: 10,
                                itemExtent: MediaQuery.of(context).size.height * 0.1,
                                itemBuilder: (context, index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                      title: Text(""),
                                      tileColor: Colors.grey,
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
            fit: BoxFit.fitWidth,
            child: AutoSizeText.rich(
        TextSpan(
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: ResponsiveFlutter.of(context).fontSize(8),
            ),
            children: [
              TextSpan(
                text: 'Notification',
                
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xfff5f5f5),
                ),
              ),
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: const Color(0xff00b98e),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
        ),
        
        textAlign: TextAlign.left,
    ),
          ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                          child: count != 0 ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: count,
                            itemExtent: 70,
                            itemBuilder: (context, index){
                              return snapshot.data[index];
                            },
                          ) : Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.23,),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: SvgPicture.asset("assets/images/Empty_Activity.svg")),

                                    // RaisedButton(
                                    //   onPressed: (){
                                    //     print("navigate to notification window");
                                    //     Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ManageNotification(currentUserId: widget.currentUserId,)));
                                    //   },
                                    //   elevation: 10,
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.016,),
                                    //     child: Text("Manage Account", style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontWeight: FontWeight.w900,
                                    //       fontSize: 18,
                                    //     ),),
                                    //   ),
                                    //   color: Color(0xff363637),
                                    // )
                                ],
                              ),
                            )
                          )
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomModalSheet(context,Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.8),),
          ],
        ),
      ),
    );
  }
}



Widget mediaPreview;
String activityFeedText;
class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String type;
  final String userProfileUrl;
  final String userId;
  final String postId;
  final String postUrl;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    this.username,
    this.type,
    this.userProfileUrl,
    this.userId,
    this.postId,
    this.postUrl,
    this.commentData,
    this.timestamp
  }); 

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc){
    return ActivityFeedItem(
      username: doc['usernameOfRequestor'],
      type: doc['type'],
      userProfileUrl: doc['photoUrlOfRequestor'],
      userId: doc['requestorId'],
      postId: doc['postId'],
      postUrl: doc["postUrl"],
      timestamp: doc['timestamp'],
      commentData: doc['commentData'],
    );
  }

  configureMediaProview(context){
    if(type == "follow request" || type == "like" || type == "comment"){
      mediaPreview = Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.013),
        child: GestureDetector(
          onTap: () async{
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            type != "follow request" ? Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: PostScreen(postId: postId, postUrl: postUrl, ownerId: user.uid, profileOfCurrentUserId: user.uid, timelineRef: false), ctx: context)) : Navigator.push(context, PageTransition(child: ProfilePage1(isProfileOwner: false, profileOfCurrentUserId: userId, isEditing: false,), type: PageTransitionType.leftToRightWithFade, ctx: context));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.13,
            child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: type != 'follow request' ? CachedNetworkImageProvider(postUrl) : AssetImage('assets/images/profile_pic1.png'),
                  )
                ),
              ),
            ),
          )
        ),
      );
    }else{
      mediaPreview = AutoSizeText(' ');
    }

    if(type == "like"){
      activityFeedText = 'likes your post';
    }else if(type == 'follow request'){
      activityFeedText = '';
    }else if(type == 'comment'){
      activityFeedText = 'comments on your post';
    }else{
      activityFeedText = 'Error Unknown type: $type';
    }
  }
  
  @override
  Widget build(BuildContext context) {
   configureMediaProview(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: ListTile(
        onTap: () async{
          FirebaseUser user = await FirebaseAuth.instance.currentUser();

          if(type == "like"){
            await activityFeedRef.document(user.uid).collection("usersFeed").document(postId).get().then((doc){
                  if(doc.exists && doc["requestorId"] == userId){
                    doc.reference.delete();
                  }
                });
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: PostScreen(postId: postId, postUrl: postUrl, ownerId: user.uid, profileOfCurrentUserId: user.uid, timelineRef: false), ctx: context));

          }
          if(type == 'comment'){
             await activityFeedRef.document(user.uid).collection("usersFeed").where("commentData", isEqualTo: commentData).getDocuments().then((snapshot){
               for(DocumentSnapshot doc in snapshot.documents){
                 if(doc.exists){
                   doc.reference.delete();
                 }
               }
             });
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: PostScreen(postId: postId, postUrl: postUrl, ownerId: user.uid, profileOfCurrentUserId: user.uid, timelineRef: false), ctx: context));
          }
          if(type == "follow request"){
            Navigator.push(context, PageTransition(child: ProfilePage1(isProfileOwner: false, profileOfCurrentUserId: userId, isEditing: false,), type: PageTransitionType.leftToRightWithFade, ctx: context));
          }
          },
          leading: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.013),
            child: GestureDetector(
            onTap: () => Navigator.push(context, PageTransition(child: ProfilePage1(isProfileOwner: false, profileOfCurrentUserId: userId, isEditing: false,), type: PageTransitionType.leftToRightWithFade, ctx: context)),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: CachedNetworkImageProvider(userProfileUrl),
            ),
        ),
          ),
        trailing: type == 'follow request' ? FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.013),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                icon: Image.asset("assets/Icon/Follow.png", height: MediaQuery.of(context).size.width * 0.1,),
                onPressed: ()async{
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  await requestRef.document(user.uid).collection("usersRequest").document(userId).updateData({
                    "type" : "accepted",
                  });
                  await followerRef.document(user.uid).collection("usersFollowers").document(userId).setData({});
                  await followingRef.document(userId).collection("usersFollowing").document(user.uid).setData({});
                  await activityFeedRef.document(user.uid).collection("usersFeed").document(userId).get().then((doc){
                    if(doc.exists){
                      doc.reference.delete();
                    }
                  });
                },
              ),
                  IconButton(
                    icon: Image.asset("assets/Icon/Unfollow.png", height: MediaQuery.of(context).size.width * 0.065,),
                    onPressed: ()async{
                      FirebaseUser user = await FirebaseAuth.instance.currentUser();
                      requestRef.document(user.uid).collection("usersRequest").document(userId).updateData({
                        "type" : "notAccepted",
                      });
                      await activityFeedRef.document(user.uid).collection("usersFeed").document(userId).get().then((doc){
                        if(doc.exists){
                          doc.reference.delete();
                        }
                      });
                    },
                  ),

                ],
              ),
            ),
          ),
        ) : mediaPreview,
        title: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
          child: GestureDetector(
            onTap: () =>  Navigator.push(context, PageTransition(child: ProfilePage1(isProfileOwner: false, profileOfCurrentUserId: userId, isEditing: false,), type: PageTransitionType.leftToRightWithFade, ctx: context)),
            child: AutoSizeText.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.7),
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    
                  ),
                  TextSpan(
                    text: '  $activityFeedText'
                  ),
                ]
              ),
               overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        
        subtitle: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
          child: AutoSizeText(
            type == 'comment' ? "${timeago.format(timestamp.toDate())} : : $commentData" : timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
            ),
          ),
        ),
      ),
    );
  }
}
