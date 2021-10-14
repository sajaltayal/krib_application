import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/bottom_sheet_service/bottom_sheet.dart';
import 'file:///Users/sajaltayal/AndroidStudioProjects/krib2/fluttershare/lib/pages/postTile.dart';
import 'package:fluttershare/pages_alag/camera_screen.dart';
import 'package:fluttershare/pages_alag/timeline_page.dart';
import 'package:fluttershare/service_and_classes/post.dart';
import 'package:fluttershare/service_and_classes/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';
final postRef = Firestore.instance.collection("posts");
class ProfilePage1 extends StatefulWidget {
  final String profileOfCurrentUserId;
  final bool isProfileOwner;
  final bool isEditing;

  ProfilePage1({this.profileOfCurrentUserId, this.isProfileOwner, this.isEditing});
  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> with TickerProviderStateMixin{
  final DateTime timestamp = DateTime.now();
  bool isLoading = false;
  bool isPublic = false;
  bool isFollowing = false;
  int followerCount;
  int followingCount;
  String variable;
  TabController _tabController;
  ScrollController _scrollController;
  bool isSending = false;
  List<Post> post = [];
  List<Post> post1 = [];
  //Future<List<Iterable<Post>>> posts;
  String bio;
  String formatAddress;
  FToast ftoast;
  Widget toast;
  Widget noToast;
  @override
  void initState() { 
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
    widget.isEditing ? null : getVerify();
    _tabController = new TabController(length: 2, vsync: this);
    //_tabController.addListener(_handleTabSelection);
    _scrollController = new ScrollController();
    getProfilePost();
    // getFollowers();
    // getFollowing();
  }

  getVerify()async{
    await _showToast();
    usersRef.document(widget.profileOfCurrentUserId).get().then((doc){
      if(doc.exists){
        if(doc['Verify'] == "Yes"){
          ftoast.showToast(child: toast,
          positionedToastBuilder: (context, child){
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width * 0.30,
              child: child,
            );
          },
          toastDuration: Duration(milliseconds: 1200)
          );
        }
        if(doc['Verify'] == "No"){
          ftoast.showToast(child: noToast,
            positionedToastBuilder: (context, child){
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                left: MediaQuery.of(context).size.width * 0.17,
                child: child,
              );
            },
            toastDuration: Duration(milliseconds: 1200)
            );
        }
      }
      
    });
  }

  _showToast() {
    toast = BlurryContainer(
        padding: EdgeInsets.symmetric(vertical: 0),
        bgColor: Colors.black.withOpacity(0.5),
        //blur: 3.5,
        borderRadius: BorderRadius.circular(25),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SvgPicture.asset("assets/Icon/confirm.svg"),
            
            Text("Verified    ", style: TextStyle(
              color: Colors.white,
              
              fontWeight: FontWeight.w400,
              fontSize: 18
            ),
            ),
        ],
        ),
    );

    noToast = BlurryContainer(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        borderRadius: BorderRadius.circular(25.0),
        bgColor: Colors.black.withOpacity(0.5),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            SvgPicture.asset("assets/Icon/Not_confirm.svg"),
            
            Text("Awaiting Verification", style: TextStyle(
              color: Colors.white,
              
              fontSize: 18,
              fontWeight: FontWeight.w400
            ),),
        ],
        ),
    );
  }

  //   _handleTabSelection() {
  //   if (_tabController.indexIsChanging) {
  //     setState(() {
  //       _tabIndex = _tabController.index;
  //     });
  //   }
  // }

  checkCurrentStatus()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).get();
    await usersRef.document(widget.profileOfCurrentUserId).get().then((doc1){
      if(doc1.exists){
        if(doc1["type"] == 'private'){
          if(doc.exists && doc['type'] == 'requested'){
      setState(() {
        variable = 'requested';
      });
    }else if((doc.exists && doc['type'] == 'notAccepted') || !doc.exists){
      setState(() {
        variable = 'notFollowing';
      });
    }else if(doc.exists && doc['type'] == 'accepted'){
      setState(() {
        variable = 'following';
      });
    }
        }
        if(doc1['type'] == 'public'){
          if(doc.exists && doc['type'] == 'requested'){
      setState(() {
        variable = 'notFollowing';
      });
    }else if((doc.exists && doc['type'] == 'notAccepted') || !doc.exists){
      setState(() {
        variable = 'notFollowing';
      });
    }else if(doc.exists && doc['type'] == 'accepted'){
      setState(() {
        variable = 'following';
      });
    }
        }
      }
    });
  }

  getProfilePost()async{
    setState(() {
      isLoading = true;
    });
    //Stream<QuerySnapshot> snapshot = postRef.document(widget.profileOfCurrentUserId).collection("usersPost").orderBy("timestamp", descending: true).snapshots();
    QuerySnapshot snapshot = await postRef.document(widget.profileOfCurrentUserId).collection("usersPost").orderBy("timestamp", descending: true).getDocuments();
    setState(() {
      isLoading = false;
      //post = snapshot.map((qShot) => qShot.documents.map((doc) => Post.fromDocument(doc))).toList() as List<Post>;
      post = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
    QuerySnapshot snapshot1 = await timelineRef.document(widget.profileOfCurrentUserId).collection("timelinePost").where("saves.${widget.profileOfCurrentUserId}", isEqualTo: true).getDocuments();
    setState(() {
      post1 = snapshot1.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  getFollowers()async{
    QuerySnapshot snapshot = await followerRef.document(widget.profileOfCurrentUserId).collection("usersFollowers").getDocuments();
    setState(() {
      followerCount = snapshot.documents.length;
    });
  }
  getFollowing()async{
    QuerySnapshot snapshot = await followingRef.document(widget.profileOfCurrentUserId).collection("usersFollowing").getDocuments();
    setState(() {
      followingCount = snapshot.documents.length;
    });

  }

  @override
  void dispose() { 
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  handleFollow()async{
    setState(() {
      isSending = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await usersRef.document(widget.profileOfCurrentUserId).get().then((doc)async{
      if(doc.exists){
        if(doc["type"] == "public"){
          setState(() {
            variable = "following";
          });
          DocumentSnapshot doc1 = await requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).get();
           if(!doc1.exists){
            doc1.reference.setData({
          "type" : "accepted",
          "requestorId" : user.uid,
          "userWhichIsRequestedId" : widget.profileOfCurrentUserId,
          "usernameOfRequestor" : doc['username'],
          "fullNameOfRequestor" : doc['fullName'],
          "photoUrlOfRequestor" : doc['photoUrl'],
          "timestamp" : timestamp,
  });
           }
           if(doc1.exists){
             doc1.reference.updateData({
               "type": "accepted"
             });
           }
          followerRef.document(widget.profileOfCurrentUserId).collection("usersFollowers").document(user.uid).setData({});
          followingRef.document(user.uid).collection("usersFollowing").document(widget.profileOfCurrentUserId).setData({});
        }
        else if(doc["type"] == "private"){
          setState(() {
            variable = "requested";
          });
          handleRequest();
        }
      }
    });
  
}

handleUnRequest()async{
  setState(() {
    isSending = false;
  });
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  setState(() {
    variable = 'notFollowing';
  });
  await activityFeedRef.document(widget.profileOfCurrentUserId).collection("usersFeed").document(user.uid).get().then((doc){
    if(doc.exists){
      doc.reference.delete();
    }
  });
  await requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).get().then((doc){
    if(doc.exists){
      doc.reference.delete();
    }
  });
}

handleRequest()async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  DocumentSnapshot doc = await usersRef.document(user.uid).get();
  DocumentSnapshot doc2 = await requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).get();
  if(doc2.exists && doc2['type'] != "accepted"){
    await requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).updateData({
      "type" : "requested",
    });

    await activityFeedRef.document(widget.profileOfCurrentUserId).collection("usersFeed").document(user.uid).setData({
        "type" : "follow request",
        "requestorId" : user.uid,
        "userWhichIsRequestedId" : widget.profileOfCurrentUserId,
        "usernameOfRequestor" : doc['username'],
        "fullNameOfRequestor" : doc['fullName'],
        "photoUrlOfRequestor" : doc['photoUrl'],
        "postUrl": "",
        "timestamp" : timestamp,
  });
  }else if(!doc2.exists){

  await requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).setData({
    "type" : "requested",
    "requestorId" : user.uid,
    "userWhichIsRequestedId" : widget.profileOfCurrentUserId,
    "usernameOfRequestor" : doc['username'],
    "fullNameOfRequestor" : doc['fullName'],
    "photoUrlOfRequestor" : doc['photoUrl'],
    "timestamp" : timestamp,
  });

   await activityFeedRef.document(widget.profileOfCurrentUserId).collection("usersFeed").document(user.uid).setData({
        "type" : "follow request",
        "requestorId" : user.uid,
        "userWhichIsRequestedId" : widget.profileOfCurrentUserId,
        "usernameOfRequestor" : doc['username'],
        "fullNameOfRequestor" : doc['fullName'],
        "photoUrlOfRequestor" : doc['photoUrl'],
        "postUrl" : "",
        "timestamp" : timestamp,
  });
  }
  if(doc2.exists){
    if(doc2['type'] == "requested"){

      await activityFeedRef.document(widget.profileOfCurrentUserId).collection("usersFeed").document(user.uid).setData({
        "type" : "follow request",
        "requestorId" : user.uid,
        "userWhichIsRequestedId" : widget.profileOfCurrentUserId,
        "usernameOfRequestor" : doc['username'],
        "fullNameOfRequestor" : doc['fullName'],
        "photoUrlOfRequestor" : doc['photoUrl'],
        "postUrl" : "",
        "timestamp" : timestamp,
  });
  }
  }
}

handleUnFollow()async{
  
FirebaseUser user = await FirebaseAuth.instance.currentUser();
DocumentSnapshot doc = await usersRef.document(user.uid).get();
  setState(() {
    isFollowing = false;
    variable = "notFollowing";
    isSending = false;
  });
  followerRef.document(widget.profileOfCurrentUserId).collection("usersFollowers").document(user.uid).get().then((doc){
    if(doc.exists){
      doc.reference.delete();
    }
  });
  followingRef.document(user.uid).collection("usersFollowing").document(widget.profileOfCurrentUserId).get().then((doc){
    if(doc.exists){
      doc.reference.delete();
    }
  });

  requestRef.document(widget.profileOfCurrentUserId).collection("usersRequest").document(user.uid).get().then((doc){
    if(doc.exists){
      doc.reference.delete();
    }
  });
  activityFeedRef.document(widget.profileOfCurrentUserId).collection("usersFeed").document(user.uid).get().then((doc){
    if(doc.exists){
      doc.reference.delete();
    }
  });



























  //delete comments and likes also from activity feed
  activityFeedRef.document(widget.profileOfCurrentUserId).collection("usersFeed").where("usernameOfRequestor", isEqualTo: doc["username"]).getDocuments().then((snapshot){
    snapshot.documents.forEach((DocumentSnapshot doc2){
      doc2.reference.delete();
    });
  });

  // postRef.document(widget.profileOfCurrentUserId).collection("usersPost").where("likes.${user.uid}", isEqualTo: true | false).getDocuments().then((snapshot)async{
  //   snapshot.documents.forEach((DocumentSnapshot doc2){
  //     doc2.reference.updateData({
  //       "likes.${user.uid}" : FieldValue.delete(),
  //     });
  //   });
  // });
  print(isSending);
}

  buildNoRow(int count, String label){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.036,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AutoSizeText(count.toString(), style: TextStyle(fontSize: 23, fontFamily: "Poppins",color: Colors.white, fontWeight: FontWeight.bold),),
          Container(
            margin: EdgeInsets.only(left: 5, bottom: MediaQuery.of(context).size.height * 0.005),
            child: AutoSizeText(label, style: TextStyle(fontSize: 12, fontFamily: "Poppins",color: Colors.grey[350],),),
          )
        ],
      ),
    );
  }

  unfollowButton(){

    return SafeArea(
      minimum: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.85),
      child: RawMaterialButton(
        elevation: 10.0,
        fillColor: Colors.black.withOpacity(0.7),
        child: Icon(Icons.more_vert_rounded, color: Colors.white,size: 30),
        shape: CircleBorder(),
        onPressed: (){
          showModalBottomSheet(context: context,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(70),
              )
            ),
          backgroundColor: Color(0x422c2c2c), 
          builder: (context){
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
                            padding: EdgeInsets.only(//left: MediaQuery.of(context).size.width * 0.05, 
                            top: MediaQuery.of(context).size.height * 0.05),
                            child: AutoSizeText(
                                  'Any Help?',
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
                            'UnFollow',
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
                            handleUnFollow();
                            Navigator.pop(context);
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
                          'Report Profile',
                          style: TextStyle(
                            fontFamily: 'Bitstream Vera Serif',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                            color: const Color(0xfffdfdff),
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                          onTap: (){
                            // raise request to delete profile







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
                            style: TextStyle(
                            fontFamily: 'Bitstream Vera Serif',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.6),
                            color: Color(0xfffdfdff),
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
                                  );
                                },                                          
                                )
                            );
                        }

  intro(User user){
    final numLines = '\n'.allMatches(user.bio).length + 1;
    print(numLines);
    print(user.bio.length);
      return Column(
        children: [
          CachedNetworkImage(
            imageUrl: user.photoUrl,
            placeholder: (context, url){
              return Shimmer.fromColors(
                baseColor: Colors.grey[500].withOpacity(0.1),
                highlightColor: Colors.white,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),)
                  ),
                  
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      )
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.31,
                          left: MediaQuery.of(context).size.width * 0.055,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: BorderedText(
                              strokeJoin: StrokeJoin.round,
                              strokeWidth: 1.3,
                              strokeColor: Colors.black,
                              child: Text(user?.fullName, 
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        variable == "following" ? unfollowButton() : Text(" "),
                        SafeArea(
                          minimum: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.85),
                          child:
                              RawMaterialButton(
                                elevation: 10,
                                fillColor: Colors.black.withOpacity(0.7),
                                child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,size: 30,),
                                shape: CircleBorder(),
                                onPressed: () => Navigator.pop(context),
                              )
                          ),

                      ],
                    ),
                    
                  );
            }
          ),

              Stack(
                children: [
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.055, MediaQuery.of(context).size.height * 0.02, MediaQuery.of(context).size.width * 0.055, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(user.location ?? "your location", style: TextStyle(color: Colors.white, fontSize: 15,),),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: numLines < 3 || user.bio.length < 36 ? AutoSizeText(
                                  user.bio ?? "Bio",
                                   style: TextStyle(
                                  color: Colors.grey[350],
                                  fontFamily: "Poppins", 
                                  fontSize: 8
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ) : ExpandableText(
                                  
                                  user.bio ?? "Bio",
                                  style: TextStyle(
                                      color: Colors.grey[350],
                                      fontFamily: "Poppins", 
                                      fontSize: 12
                                      ),
                                      
                                  expandText: "\nshow more",
                                  linkStyle: TextStyle(
                                      color: Color(0xffB6D1F2),
                                      fontFamily: "Poppins", 
                                      fontSize: 12
                                      ),
                                  collapseText: "\nshow less",
                                  
                                  maxLines: 3,
                                  
                                  ),
                                  
                                )
                              ),
                            
                          ],
                        ),
                        variable != 'following' ? isPublic ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildNoRow(followerCount,"Followers"),
                            buildNoRow(followingCount, "Following"),
                          ],
                        ) : Padding(
                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1,),
                          child: Image.asset("assets/images/lock.png", height: MediaQuery.of(context).size.height * 0.05,),
                        ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildNoRow(followerCount,"Followers"),
                            buildNoRow(followingCount, "Following"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
             
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         // widget.isProfileOwner ? buildProfilePost() : Text(''),
          variable == "following" ? Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,top: MediaQuery.of(context).size.height * 0.02),
            child: buildProfilePost1(),
          ) : Text(''), 

          variable == "notFollowing" || variable == "requested" ? GestureDetector(
            onTap: variable == "notFollowing" ? handleFollow : handleUnRequest,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.017),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Center(
                  child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: variable == "notFollowing" ? isSending ? Shimmer.fromColors(
                    baseColor: Color(0xffc47b1b),
                    highlightColor: Colors.grey[900],
                    child: AutoSizeText("Sending...", 
                    style: TextStyle(
                      color: Color(0xffc47b1b),
                      fontSize: 25,
                      fontFamily: "Poppins",
                    ),
                    maxLines: 1,
                    ),
                  ) : Image.asset("assets/Icon/Follow.png", 
                  height: MediaQuery.of(context).size.width * 0.2,) : AutoSizeText("That's one small click for you,\none giant leap for friendship.", maxLines: 2, style: TextStyle(color: Color(0xffc47b1b), fontSize: 18), textAlign: TextAlign.center),
                )),
                
                ),
            ),
          ) : Text(''),

      // variable == "requested" ? GestureDetector(
      // onTap: handleUnRequest,
      // child: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     color: Colors.white,
      //   ),
      //     width: MediaQuery.of(context).size.width * 0.9,
      //     height: MediaQuery.of(context).size.height * 0.065,
      //   child: Center(
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 10),
      //       child: AutoSizeText("Requested Requested is button to follow someone on your side. this is the time to do that", maxLines: 2,),
      //     )),
        
      //         ),
      // ) : Text(''), 
        ],
      );
}

buildSavedProfilePost(){
  if(isLoading){
    return Shimmer.fromColors(
      child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            baseColor: Colors.grey[500].withOpacity(0.1),
            highlightColor: Colors.grey[500].withOpacity(0.3),
    );
  }

  List<GridTile> gridTile1 = [];
  post1.forEach((post1){
    gridTile1.add(GridTile(child: PostTile(post1, widget.profileOfCurrentUserId, true, false),));
  });

  if(post1.isEmpty){
    return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    color: Colors.transparent,
    child: Center(
      child: Text("Nothing to show",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins"),
      ),
    ),
  ) ;
  }

  if(gridTile1.length >= 7){
    return GridView.count(
    padding: !widget.isProfileOwner ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015) : EdgeInsets.zero,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    childAspectRatio: 1.0,
    mainAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    children: gridTile1,
  ) ;
  }
  if(gridTile1.length < 7){
    return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    color: Colors.transparent,
    child: GridView.count(
    padding: !widget.isProfileOwner ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015) : EdgeInsets.zero,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    childAspectRatio: 1.0,
    mainAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    children: gridTile1,
  ));
  }
}

buildProfilePost1(){
  if(isLoading){
    return Shimmer.fromColors(
      child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            baseColor: Colors.grey[500].withOpacity(0.1),
            highlightColor: Colors.grey[500].withOpacity(0.3),
    );
  }
  List<GridTile> gridTile = [];
  post.forEach((post){
    gridTile.add(GridTile(child: PostTile(post, widget.profileOfCurrentUserId, false, widget.isEditing)));
  });

  return gridTile.isEmpty ? Container(
    height: MediaQuery.of(context).size.height * 0.4,
    color: Colors.transparent,
    child: Center(
      child: Text("Nothing to show",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins"),
      ),
    ),
  ) : post.length >= 7 ? GridView.count(
    padding: !widget.isProfileOwner ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015) : EdgeInsets.zero,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    childAspectRatio: 1.0,
    mainAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    children: gridTile,
  ) : Container(
    height: MediaQuery.of(context).size.height * 0.48,
    color: Colors.transparent,
    child: GridView.count(
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    childAspectRatio: 1.0,
    mainAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
    children: gridTile,
  ));
}

buildProfilePost(){
  return TabBar(
    controller: _tabController,
    indicatorColor: Color(0xff707070),
    tabs: [
      Tab(child: Text("Publish",
        style: TextStyle(fontSize: 16, color: Color(0xffB6D1F2), fontWeight: FontWeight.w300),)
      ),
      Tab(child: Text("Save", style: TextStyle(fontSize: 16, color: Color(0xffB6D1F2), fontWeight: FontWeight.w300),)),
    ],
  );
      // return SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       new Container(
      //         child: new TabBar(
      //           //controller: _tabController,
      //           tabs: [
      //           new Tab(
      //             // icon: const Icon(Icons.home),
      //             child: Text("Publish",
      //             style: TextStyle(fontSize: 16, color: Color(0xffB6D1F2), fontWeight: FontWeight.w300),
      //             ),
                  
      //           ),
      //           new Tab(
      //             // icon: const Icon(Icons.home),
      //             child: Text("Save",
      //             style: TextStyle(fontSize: 16, color: Color(0xffB6D1F2), fontWeight: FontWeight.w300),
      //             ),
                  
      //           ),
      //         ],
      //         ),
      //       ),

      //       Container(
      //       child: [
      //           Padding(
      //             padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, MediaQuery.of(context).size.width * 0.03, 0),
      //             child: buildProfilePost1(),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, MediaQuery.of(context).size.width * 0.03, 0),
      //             child: buildSavedProfilePost(),
      //           ),
      //       ][_tabIndex],
      //       ),
      //     ],
      //   ),
      // );
      
  // return Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   children: [
  //     TextButton(
  //       onPressed: () {
  //         setState(() {
  //           postOrient = "profilePost";
  //         });
  //       },
  //       child: Text("Post", style: TextStyle(color: postOrient == "profilePost" ? Colors.orange : Colors.blue, fontSize: 20, fontFamily: "Helvetica"),),
  //     ),
  //     widget.isProfileOwner ? TextButton(
  //       onPressed: () {
  //         setState(() {
  //           postOrient = "savedProfilePost";
  //         });
  //       },
  //       child: Text("Saved", style: TextStyle(color: postOrient == "savedProfilePost" ?  Colors.orange : Colors.blue, fontSize: 20, fontFamily: "Helvetica"),),
  //     ) : Text(''),
  //   ],
  // );
}

topBottom(User user){
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) {
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
                            color: Color(0xff363637),
                          ),
                          
                          child: Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                            child: TextFormField(
                              initialValue: user.bio,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              onChanged: (val){
                                this.bio = val.toString();
                              },
                              style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins", 
                                            fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                            ),
                              decoration: InputDecoration(
                                labelText: "Bio...",
                                labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins", 
                                            fontSize: 20,
                                            ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff363637)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff363637)),
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
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton.icon(
                              color: Color(0xff363637),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                              icon: Icon(
                                  Icons.location_on_outlined,
                                ),
                              label: Text("Your Location"),
                              textColor: Colors.white,
                              onPressed: ()async{
                                setState(() {
                                  isLoading = true;
                                });
                                Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
                                Placemark placemark = placemarks[0];
                                String formattedAddress = "${placemark.locality}, ${placemark.country}";
                                formatAddress = formattedAddress;
                                print(formatAddress);
                                usersRef.document(widget.profileOfCurrentUserId).updateData({
                                    "location" : formatAddress != null ? formatAddress : user.location,
                                  });
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.425,
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
                                child: Text("Save"),
                                callback: (){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  usersRef.document(widget.profileOfCurrentUserId).updateData({
                                    "bio" : bio != null ? bio : user.bio,
                                    "location" : formatAddress != null ? formatAddress : user.location,
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
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


  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder(
        future: usersRef.document(widget.profileOfCurrentUserId).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            if(!widget.isProfileOwner){
              checkCurrentStatus();
            }
            print(MediaQuery.of(context).size.width * 0.028);
            print(MediaQuery.of(context).size.height * 0.0145);
            getFollowing();
            getFollowers();
            return Container(
              height: double.maxFinite,
              width: double.maxFinite,
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
              child: Shimmer.fromColors(
          baseColor: Colors.grey[500].withOpacity(0.1),
          highlightColor: Colors.grey[500].withOpacity(0.3),
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),)
                    ),
                ),
                Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.007, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.007, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.029, left: MediaQuery.of(context).size.width * 0.055),
                        height: MediaQuery.of(context).size.height * 0.0145,
                        width: MediaQuery.of(context).size.width * 0.415,
                        color: Colors.grey,
                      )

                    ],
                  ),
                ],),

                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(3),
                      height: MediaQuery.of(context).size.height * 0.275,
                      width: MediaQuery.of(context).size.width * 0.084,
                      
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15)
                      ),
                    )),
                )

              ],),
          )
        ),
            );
          }
          User user = User.fromDocument(snapshot.data);
          isPublic = (user.type == 'public');
          final numLines = '\n'.allMatches(user.bio).length + 1;
          print(numLines);
          print(user.bio.length);
          return widget.isProfileOwner ? Container(
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
            child: Stack(
              children: [
                NestedScrollView(
                  reverse: false,
                  physics: NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  headerSliverBuilder: (context, value){
                    return [
                      SliverAppBar(
                        toolbarHeight: MediaQuery.of(context).size.height * 0.325,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        flexibleSpace: CachedNetworkImage(
                        imageUrl: user.photoUrl,
                        placeholder: (context, url){
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[500].withOpacity(0.1),
                            highlightColor: Colors.white,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.36,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                )
                              ),
                              
                            ),
                          );
                        },
              errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white),
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                  width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        )
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.31,
                            left: MediaQuery.of(context).size.width * 0.055,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: BorderedText(
                                strokeJoin: StrokeJoin.round,
                                strokeWidth: 1.3,
                                strokeColor: Colors.black,
                                child: Text(user?.fullName, 
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                         

                            widget.isEditing ? Positioned.fill(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, PageTransition(child: CameraScreen(currentUserId: widget.profileOfCurrentUserId, isProfileEdit: true,), type: PageTransitionType.fade));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20)
                                    ),
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.edit_outlined, 
                                    color: Colors.white,
                                    size: 50
                                    )
                                  ),
                                ),
                              ),
                            ) : Text(''),

                            SafeArea(
                            minimum: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.85),
                            child:RawMaterialButton(
                              elevation: 10,
                              fillColor: Colors.black.withOpacity(0.7),
                              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,size: 30,),
                              shape: CircleBorder(),
                              onPressed: () => Navigator.pop(context),
                            )
                            ),
                        ],
                      ),
                      
                    );
              }
            ),
                      ),
                      SliverToBoxAdapter(child: Stack(
                  children: [
                    widget.isEditing? Positioned.fill(
                      right: MediaQuery.of(context).size.width * 0.36,
                      top:  MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.025,
                            child: GestureDetector(
                              onTap: () => topBottom(user),
                              child: Container(
                                child: IconButton(
                                  icon: Icon(Icons.edit_outlined, color: Colors.white, size: 30,),
                                  onPressed: () => topBottom(user),
                                  ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ) : Text(''),
                    Padding(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.055, MediaQuery.of(context).size.height * 0.02, MediaQuery.of(context).size.width * 0.055, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => widget.isEditing ? topBottom(user) : () => print(user.bio.length),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => print(user.bio.length),
                                  child: AutoSizeText(user.location ?? "your location", style: TextStyle(color: Colors.white, fontSize: 15,),)),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: numLines < 3 || user.bio.length < 30 ? AutoSizeText(
                                      user.bio ?? "Bio",
                                      style: TextStyle(
                                      color: Colors.grey[350],
                                      fontFamily: "Poppins", 
                                      fontSize: 8
                                      ),
                                      maxLines: 3,
                                    ) : ExpandableText(
                                      user.bio ?? "Bio",
                                      style: TextStyle(
                                      color: Colors.grey[350],
                                      fontFamily: "Poppins", 
                                      fontSize: 12
                                      ),
                                      expandText: "\nshow more",
                                      linkStyle: TextStyle(
                                      color: Color(0xffB6D1F2),
                                      fontFamily: "Poppins", 
                                      fontSize: 12
                                      ),
                                      collapseText: "\nshow less",
                                      
                                      
                                      maxLines: 3,
                                      
                                      ),
                                      
                                    )
                                  ),
                                
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildNoRow(followerCount,"Followers"),
                              buildNoRow(followingCount, "Following"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                      ),
                      
                      
                SliverPadding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02, top: 0),
                  sliver: SliverToBoxAdapter(child: buildProfilePost()))
                   // SliverToBoxAdapter(child: buildProfilePost()),  
                    // SliverToBoxAdapter(child: Stack(
                    //   children:[
                    //     bottomModalSheet(context, Offset(MediaQuery.of(context).size.width * 0.83, MediaQuery.of(context).size.height * 0.91),),
                    //   ]
                    // ))
                    ];
                  },
                  body: TabBarView(
                  controller: _tabController,
                  children: [
                  Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,),
                  child: buildProfilePost1(),
                  ),
                  Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,),
                  child: buildSavedProfilePost(),
                  )
                  ],
                  ),
                ),
                bottomModalSheet(context, Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.835),),
             
                  
              ]
              ),
          )
          //       body: 
          : Container(
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
            child: Stack(
              children: [
                Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        intro(user),
                      ],
                    ),
                  ),
                ),
                bottomModalSheet(context, Offset(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.835),),
              ],
            ),
          );
        }
      )
    );
  }
}

//  widget.isProfileOwner ? buildProfilePost()  : Text(''),

//           variable == 'notFollowing' ? Padding(
//             padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015, right: MediaQuery.of(context).size.width * 0.015, top: 15),
//             child: 
//                   GestureDetector(
//                     onTap: handleFollow,
//                     child: Container(
//                       color: Colors.grey,
//                       width: MediaQuery.of(context).size.width * 0.97,
//                       height: 50,
//                       child: Center(child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: AutoSizeText("Follow is button to follow someone on your side. this is the time to do that", maxLines: 2,),
//                       )),
                      
//                       ),
//                   ),
//           )  : Text(''),

//           variable == "following" ? Padding(
//             padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,),
//             child: buildProfilePost1(),
//           )  : Text(''),

//           variable == "requested" ? Padding(
//             padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015, right: MediaQuery.of(context).size.width * 0.015),
//             child: GestureDetector(
//               onTap: handleUnRequest,
//               child: Container(
//                 color: Colors.grey,
//                         width: MediaQuery.of(context).size.width * 0.97,
//                         height: 50,
//                       child:Center(child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           child: AutoSizeText("Requested Requested is button to follow someone on your side. this is the time to do that", maxLines: 2,),
//                         )),
                      
//                       ),
//             ),
               
//           ) : Text(''),


// AutoSizeText(user.bio ?? "Bio", 
//                                     style: TextStyle(
//                                       color: Colors.grey[350],
//                                       fontFamily: "Poppins", 
//                                       fontSize: 8
//                                       ),
//                                       maxLines: 3,
//                                       ),